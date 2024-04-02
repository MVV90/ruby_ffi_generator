require "open3"

module FFIGenerate
  class Generator

    C_PATH_COMMANDS = [
      "gcc     -E -Wp,-v -xc   /dev/null",
      "clang   -E -Wp,-v -xc   /dev/null",
      "g++     -E -Wp,-v -xc++ /dev/null",
      "clang++ -E -Wp,-v -xc++ /dev/null",
    ]

    attr_reader :module_name,
                :headers,
                :cflags,
                :ffi_lib,
                :ffi_lib_flags,
                :blocking,
                :output,
                :translation_unit,
                :declarations,
                :rename_imported_functions,
                :skip_cpath_auto_includes,
                :prefixes,  # TODO: deprecated
                :suffixes   # TODO: deprecated

    def initialize(options = {})
      @module_name   = options[:module_name] || fail("No module name given.")
      @headers       = options[:headers] || fail("No headers given.")
      @cflags        = options.fetch(:cflags, [])
      @ffi_lib       = options[:ffi_lib]
      @ffi_lib_flags = options[:ffi_lib_flags]
      @ffi_lib_path_env = "#{@module_name.upcase}_PATH".gsub(/[\W]+/, "")
      @blocking      = options.fetch(:blocking, [])
      @output        = options.fetch(:output, $stdout)
      @translation_unit = nil
      @declarations = nil
      @rename_imported_functions = options[:rename_imported_functions]
      @skip_cpath_auto_includes = !!options.fetch(:skip_cpath_auto_includes, false)
      @prefixes      = options.fetch(:prefixes, []) # TODO: deprecated
      @suffixes      = options.fetch(:suffixes, []) # TODO: deprecated

      auto_include_c_paths
    end

    def generate
      code = send("generate_rb")
      if @output.is_a?(String)
        File.open(@output, "w") { |file| file.write(code) }
        puts "lib/ffi_generator/generator.rb - Created new FFI wrapper: #{@output}"
      else
        @output.write(code)
      end
    end

    def auto_include_c_paths
      return puts("Skipping CPATH mutation - found skip_cpath_auto_includes") if @skip_cpath_auto_includes

      include_dirs = C_PATH_COMMANDS.map do |cmd|
        _, _, stdout, stderr = run_shell(cmd)
        output = stdout.to_s + "\n" + stderr.to_s
        #
        # Output contains both include types, but we only need one.
        # Skip  -->      #include "..."
        # only need -->  #include <...>
        #
        output = output.split("#include <...> search starts here:").last
        output = output.split("End of search list.").first
        paths = output.split("\n").map(&:strip)
        paths = paths.select {|path| File.directory?(path)} # Remove anything not valid. Example: mac gives "System/Library/Frameworks (framework directory)" output, that appears we can skip without consequences.
        paths
      end.flatten.uniq

      ENV["CPATH"] = ([ENV["CPATH"]] + include_dirs).compact.join(":") if include_dirs.length >= 1
      puts "CPATH is: #{ENV["CPATH"]}"
      include_dirs
    end

    def run_shell(cmd)
      process_thread_waiter, proces_return_code, stdout, stderr = Open3.popen3(cmd) do |stdin, stdout, stderr, process_thread_waiter|
        [process_thread_waiter, process_thread_waiter.value.to_i, stdout.read, stderr.read]
      end
    end

    def translation_unit
      return @translation_unit unless @translation_unit.nil?

      args = @cflags

      index = Clang::Index.create

      source_files = @headers.reject { |h| h.is_a?(Regexp) }
      @translation_unit = index.parse_translation_unit(source_files: source_files, arguments: @cflags)

      $stderr.puts(@translation_unit.get_diagnostics) # print out any errors encountered while parsing the header files

      return @translation_unit
    end

    def declarations
      return @declarations unless @declarations.nil?

      header_files = translation_unit.included_files
        .select { |file| @headers.any? { |header| header.is_a?(Regexp) ? header =~ file : file.end_with?(header) } }

      declaration_cursors = translation_unit.get_cursor.children
        .reject { |cursor| [:macro_expansion, :inclusion_directive, :var_decl].include?(cursor.kind) }
        # only include declarations from one of the target header files
        .select { |cursor| header_files.include?(cursor.location.file) }

      is_nested_declaration = []
      min_offset = declaration_cursors.last.location.offset
      declaration_cursors.reverse_each do |declaration_cursor|
        offset = declaration_cursor.location.offset
        is_nested_declaration.unshift(offset > min_offset)
        min_offset = offset if offset < min_offset
      end

      @declarations = []
      @declarations_by_name = {}
      @declarations_by_type = {}
      previous_declaration_end = translation_unit.get_cursor.location # start at beginning of file
      declaration_cursors.each_with_index do |declaration_cursor, index|
        comment = []
        unless is_nested_declaration[index]
          comment_range = Clang::SourceRange.get(start: previous_declaration_end, end: declaration_cursor.location)
          comment, _ = extract_comment(translation_unit, comment_range)
          previous_declaration_end = declaration_cursor.extent.end
        end

        read_declaration(declaration_cursor, comment)
      end

      @declarations
    end

    def read_declaration(declaration_cursor, comment)
      name = read_name(declaration_cursor, :is_function)

      declaration = case declaration_cursor.kind
      when :enum_decl
        read_enum_declaration(declaration_cursor, comment, name)
      when :struct_decl, :union_decl
        read_struct_or_union_declaration(declaration_cursor, comment, name)
      when :function_decl
        read_function_declaration(declaration_cursor, comment, name)
      when :typedef_decl
        read_typedef_declaration(declaration_cursor, comment, name)
      when :macro_definition
        read_macro_definition(declaration_cursor, name)
      else
        raise declaration_cursor.kind.to_s
      end

      return nil if declaration.nil?
      @declarations.delete(declaration)
      @declarations << declaration
      @declarations_by_name[name] = name.raw unless name.nil?
      type = declaration_cursor.type
      @declarations_by_type[type] = declaration unless type == nil

      declaration
    end

    def read_enum_declaration(declaration_cursor, comment, name)
      enum_description = []
      constant_descriptions = {}
      current_description = enum_description
      comment.each do |line|
        if line.gsub!(/@(.*?): /, '')
          current_description = []
          constant_descriptions[$1] = current_description
        end
        current_description = enum_description if line.strip.empty?
        current_description << line
      end

      constants = []
      previous_constant_location = declaration_cursor.location
      next_constant_value = 0
      declaration_cursor.children.each do |enum_constant|
        constant_name = read_name(enum_constant)

        constant_location = enum_constant.location
        constant_comment_range = Clang::SourceRange.get(start: previous_constant_location, end: constant_location)
        constant_description, _ = extract_comment(translation_unit, constant_comment_range)
        constant_description.concat(constant_descriptions[constant_name.raw] || [])
        previous_constant_location = constant_location

        begin
          value_cursor = enum_constant.children.first
          constant_value = if value_cursor
            parts = []
            value_cursor.extent.tokens.each do |token|
              spelling = token.spelling
              case token.kind
              when :literal
                parts << spelling
              when :punctuation
                case spelling
                when "+", "-", "<<", ">>", "(", ")"
                  parts << spelling
                else
                  raise ArgumentError
                end
              else
                raise ArgumentError
              end
            end
            eval(parts.join)
          else
            next_constant_value
          end

          constants << { name: constant_name, value: constant_value, comment: constant_description }
          next_constant_value = constant_value + 1
        rescue ArgumentError
          puts "Warning: Could not process value of enum constant \"#{constant_name.raw}\""
        end
      end

      return Enum.new(self, name, constants, enum_description)
    end

    def read_struct_or_union_declaration(declaration_cursor, comment, name)
      struct = @declarations_by_type[declaration_cursor.type] || StructOrUnion.new(self, name, (declaration_cursor.kind == :union_decl))
      raise if !struct.fields.empty?
      struct.description.concat(comment)

      struct_children = declaration_cursor.children
      previous_field_end = declaration_cursor.location
      last_nested_declaration = nil
      until struct_children.empty?
        child = struct_children.shift
        case child.kind
        when :struct_decl, :union_decl
          last_nested_declaration = read_declaration(child, [])
        when :field_decl
          field_name = read_name(child)
          field_extent = child.extent

          field_comment_range = Clang::SourceRange.get(start: previous_field_end, end: field_extent.start)
          field_comment, _ = extract_comment(translation_unit, field_comment_range)

          # check for comment starting on same line
          next_field_start = struct_children.first ? struct_children.first.location : declaration_cursor.extent.end
          following_comment_range = Clang::SourceRange.get(start: field_extent.end, end: next_field_start)
          following_comment, following_comment_token = extract_comment(translation_unit, following_comment_range, false)
          if following_comment_token && following_comment_token.location.line == field_extent.end.line
            field_comment = following_comment
            previous_field_end = following_comment_token.extent.end
          else
            previous_field_end = field_extent.end
          end

          field_type = resolve_type(child.type)
          last_nested_declaration.name ||= Name.new(name.parts + field_name.parts) if last_nested_declaration
          last_nested_declaration = nil
          struct.fields << { name: field_name, type: field_type, comment: field_comment }
        else
          raise
        end
      end

      return struct
    end

    def read_function_declaration(declaration_cursor, comment, name)
      function_description = []
      return_value_description = []
      parameter_descriptions = {}
      current_description = function_description
      has_unsupported_variables = nil
      parameters = []
      first_parameter_type = nil

      comment.each do |line|
        if line.gsub!(/\\param (.*?) /, '')
          current_description = []
          parameter_descriptions[$1] = current_description
        end
        current_description = return_value_description if line.gsub!('\\returns ', '')
        current_description << line
      end

      return_type = resolve_type(declaration_cursor.result_type)

      declaration_cursor.children.each do |function_child|
        next if function_child.kind != :parm_decl

        param_name = read_name(function_child, :is_function)
        tokens = function_child.extent.tokens
        is_array = tokens.any? { |t| t.spelling == "[" }
        param_type = resolve_type(function_child.type, is_array)
        param_name ||= param_type.name
        param_name ||= Name.new([])
        first_parameter_type ||= function_child.type

        has_unsupported_variables = check_unsupported_c_features(tokens)

        parameters << { name: param_name, type: param_type, tokens: tokens }
      end

      parameters.each_with_index do |parameter, index|
        parameter[:description] = parameter[:name] && parameter_descriptions[parameter[:name].raw]
        parameter[:description] ||= parameter_descriptions.values[index] if parameter_descriptions.size == parameters.size # workaround for wrong names
        parameter[:description] ||= []
      end

      function = FunctionOrCallback.new(self, name, parameters, return_type, false, @blocking.include?(name.raw), function_description, return_value_description)

      pointee_declaration = first_parameter_type && get_pointee_declaration(first_parameter_type)
      if pointee_declaration
        type_prefix = pointee_declaration.name.parts.join.downcase
        function_name_parts = name.parts.dup
        while type_prefix.start_with? function_name_parts.first.downcase
          type_prefix = type_prefix[function_name_parts.first.size..-1]
          function_name_parts.shift
          break if function_name_parts.empty?
        end
        if type_prefix.empty?
          pointee_declaration.oo_functions << [Name.new(function_name_parts), function]
        end
      end

      if has_unsupported_variables && has_unsupported_variables[0]
        function.failed_clang_parse_metadata = has_unsupported_variables[1]
      end

      return function
    end

    def check_unsupported_c_features(tokens)
      # TODO: add more unsupported feature checks here
      found_unsupported = false
      failed_metadata = {}
      failed_metadata[:failed_reasons] = []

      # va_list - Is a macro which creates a hard to parse situation.
      #         - If we compiled to a ruby c-extension we could
      #         - wrap the va_list with an interface.
      #         - docs: https://pubs.opengroup.org/onlinepubs/000095399/basedefs/stdarg.h.html
      if tokens.select{|token| token.spelling == "va_list"}.any?
        found_unsupported = true
        failed_metadata[:failed_reasons] << "Found macro 'va_list' which cannot be parsed easily. This 'va_list' macro would require compilation to determine full type information."
      end

      return found_unsupported, failed_metadata
    end

    def read_typedef_declaration(declaration_cursor, comment, name)
      typedef_children = declaration_cursor.children
      if typedef_children.count == 1
        child_declaration = @declarations_by_type[typedef_children.first.type]
        child_declaration.name = name if child_declaration && child_declaration.name.nil?
        return nil
      elsif typedef_children.count > 1
        return_type = resolve_type(typedef_children.first.type)
        parameters = []
        typedef_children.each do |param_decl|
          param_name = read_name(param_decl)
          param_type = resolve_type(param_decl.type)
          param_name ||= param_type.name
          parameters << { name:param_name, type: param_type, description: [] }
        end
        return FunctionOrCallback.new(self, name, parameters, return_type, true, false, comment, [])
      else
        return nil
      end
    end

    def read_macro_definition(declaration_cursor, name)
      tokens = declaration_cursor.extent.tokens

      return nil if tokens.count == 0 # skip empty macro
      return nil if tokens.count == 1

      tokens.shift
      begin
        parameters = nil
        if tokens.first.spelling == "("
          tokens_backup = tokens.dup
          begin
            parameters = []
            tokens.shift
            loop do
              token = tokens.shift
              case token.kind
              when :identifier
                parameters << token.spelling
              when :punctuation
                break if token.spelling == ")"
                raise(ArgumentError) unless token.spelling == ","
              else
                raise ArgumentError
              end
            end
          rescue ArgumentError
            parameters = nil
            tokens = tokens_backup
          end
        end
        value = []
        until tokens.empty?
          token = tokens.shift
          case token.kind
          when :literal
            value << token.spelling
          when :punctuation
            case token.spelling
            when "+", "-", "<<", ">>", ")"
              value << token.spelling
            when ","
              value << ", "
            when "("
              if tokens[1].spelling == ")"
                tokens.delete_at(1)
              else
                value << token.spelling
              end
            else
              raise ArgumentError
            end
          when :identifier
            raise(ArgumentError) unless parameters
            if parameters.include?(token.spelling)
              value << token.spelling
            elsif token.spelling == "NULL"
              value << "nil"
            else
              if !tokens.empty? && tokens.first.spelling == "("
                tokens.shift
                if token.spelling == "strlen"
                  argument_token = tokens.shift
                  second_token = tokens.shift
                  raise(ArgumentError) unless argument_token.kind == :identifier && second_token.spelling == ")"
                  value << "#{argument_token.spelling}.length"
                else
                  value << [:method, read_name(token.spelling)]
                  value << "("
                end
              else
                value << [:constant, read_name(token.spelling)]
              end
            end
          when :keyword
            raise(ArgumentError) unless token.spelling == "sizeof" && tokens[0].spelling == "(" && tokens[1].kind == :literal && tokens[2].spelling == ")"
            tokens.shift
            argument_token = tokens.shift
            value << "#{argument_token.spelling}.length"
            tokens.shift
          else
            raise ArgumentError
          end
        end
        return Define.new(self, name, parameters, value)
      rescue ArgumentError
        puts "Warning: Could not process value of macro \"#{name.raw}\""
        return nil
      end
    end

    def resolve_type(full_type, is_array = false)
      canonical_type = full_type.canonical
      data_array = case canonical_type.kind
      when :void, :bool, :u_char, :u_short, :u_int, :u_long, :u_long_long, :char_s, :s_char, :short, :int, :long, :long_long, :float, :double
        PrimitiveType.new(canonical_type.kind)
      when :pointer
        if is_array
          ArrayType.new(resolve_type(canonical_type.pointee), nil)
        else
          pointee_type = canonical_type.pointee
          type = case pointee_type.kind
          when :char_s
            StringType.new
          when :record
            @declarations_by_type[pointee_type.declaration.type]
          when :function_proto
            @declarations_by_type[full_type]
          else
            nil
          end

          if type.nil?
            pointer_depth = 0
            pointee_name = ""
            current_type = full_type
            loop do
              declaration_cursor = current_type.declaration
              pointee_name = read_name(declaration_cursor)
              break if pointee_name

              case current_type.kind
              when :pointer
                pointer_depth += 1
                current_type = current_type.pointee
              when :unexposed
                break
              else
                pointee_name = Name.new(current_type.kind_spelling.split("_"))
                break
              end
            end
            type = PointerType.new(pointee_name, pointer_depth)
          end

          type
        end
      when :record
        type = @declarations_by_type[canonical_type]
        type &&= ByValueType.new(type)
        type || UnknownType.new # TODO
      when :enum
        @declarations_by_type[canonical_type] || UnknownType.new # TODO
      when :constant_array
        ArrayType.new(resolve_type(canonical_type.array_element), canonical_type.array_size)
      when :unexposed, :function_proto
        UnknownType.new
      when :incomplete_array
        PointerType.new(resolve_type(canonical_type.array_element).name, 1)
      else
        raise NotImplementedError, "No translation for values of type #{canonical_type.kind}"
      end
    end

    def read_name(source, object_type=nil)
      source = source.spelling if source.is_a?(Clang::Cursor)
      return nil if source.empty?
      trimmed = source
      trimmed = transform_by_renaming_imported_function_names(trimmed) if object_type == :is_function
      trimmed = trimmed.sub(/^(#{@prefixes.join('|')})/, '')
      trimmed = trimmed.sub(/(#{@suffixes.join('|')})$/, '')
      # parts = trimmed.split(/_|(?=[A-Z][a-z])|(?<=[a-z])(?=[A-Z])/).reject(&:empty?) # TODO: deprecate with prefixes
      parts = trimmed.split(/_/).reject(&:empty?)
      Name.new(parts, source)
    end

    # Rename imported library function names based on regex patterns.
    #
    # The interface follows this data structure:
    #
    # rename_imported_functions: {
    #   # or alias when_func_name_matches_regex: [
    #   when_matches_regex: [
    #     {
    #       regex_pattern: /^example_/,
    #       replace_with: "",
    #       append_to_start: "f__",
    #     },
    #     {
    #       regex_pattern: "my_name_to_match",
    #       replace_with: "__my_custom_name",
    #     },
    #     {
    #       regex_pattern: /has_a/,
    #       append_to_end: "?",
    #       append_to_start: "rb_",
    #     }
    #   ]
    # },
    #
    # Which if the C/C++ header has functions named:
    #  - example_lib_call_1
    #  - has_a_thing
    #  - my_name_to_match
    #
    # They will transform to ruby functions named:
    #  - f__lib_call_1
    #  - rb_has_a_thing?
    #  - __my_custom_name
    #
    # Order of transform operations is:
    #  1. replace_with
    #  2. append_to_start
    #  3. append_to_end
    #
    def transform_by_renaming_imported_function_names(func_name)
      if @rename_imported_functions && @rename_imported_functions.is_a?(Hash)
        [:when_matches_regex, :when_func_name_matches_regex].each do |operation_type|
          if @rename_imported_functions[operation_type].is_a?(Array)
            @rename_imported_functions[operation_type].each do |operation|
              func_name = transform_function_name(func_name, operation) if operation.is_a?(Hash)
            end
          end
        end
      end

      func_name
    end

    def transform_function_name(func_name, operation)
      found_match = func_name[operation[:regex_pattern]]
      append_to_start = !operation[:append_to_start].to_s.empty?
      append_to_end = !operation[:append_to_end].to_s.empty?
      replace_with = operation.keys.include?(:replace_with)

      if found_match
        # *Update the docs if you change the ordering of these operations* which should be:
        #  1. replace_with
        #  2. append_to_start
        #  3. append_to_end
        func_name = func_name.gsub(operation[:regex_pattern], operation[:replace_with]) if replace_with
        func_name = "#{operation[:append_to_start]}#{func_name}" if append_to_start
        func_name += operation[:append_to_end] if append_to_end
      end

      func_name
    end

    def get_pointee_declaration(type)
      canonical_type = type.canonical
      return nil if canonical_type.kind != :pointer
      pointee_type = canonical_type.pointee
      return nil if pointee_type.kind != :record
      @declarations_by_type[pointee_type.declaration.type]
    end

    def extract_comment(translation_unit, range, search_backwards = true)
      tokens = range.tokens

      iterator = search_backwards ? tokens.reverse_each : tokens.each
      comment_lines = []
      comment_token = nil
      comment_block = false
      iterator.each do |token|
        next if token.kind != :comment
        comment = token.spelling
        lines = comment.split("\n").map do |line|
          line.sub!(/\ ?\*+\/\s*$/, '')
          line.sub!(/^\s*\/?[*\/]+ ?/, '')
          line.gsub!(/\\(brief|determine) /, '')
          line.gsub!('[', '(')
          line.gsub!(']', ')')
          line
        end
        comment_lines = lines + comment_lines
        comment_token = token
        comment_block = !comment_block if comment == "///"
        break unless comment_block && search_backwards
      end

      return comment_lines, comment_token
    end

    def inspect
      "#<#{self.class.name}:#{object_id} module_name:#{@module_name} ffi_lib:#{@ffi_lib} headers:#{@headers} cflags:#{cflags} blocking:#{@blocking} ffi_lib_flags:#{@ffi_lib_flags} output:#{@output} >"
    end

  end
end
