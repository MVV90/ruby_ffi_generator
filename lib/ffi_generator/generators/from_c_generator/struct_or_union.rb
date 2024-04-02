module FFIGenerate
  class Generator
    class StructOrUnion < Type

      attr_accessor :writer, :name, :description
      attr_reader :fields, :oo_functions, :written

      def initialize(generator, name, is_union)
        @generator = generator
        @writer = generator.writer
        @name = name
        @is_union = is_union
        @description = []
        @fields = []
        @oo_functions = []
        @written = false
      end

      def write_ruby
        writer.comment do
          writer.write_description @description
          unless @fields.empty?
            writer.puts "", "= Fields:"
            @fields.each do |field|
              writer.puts ":#{field[:name].to_ruby_downcase} ::"
              writer.write_description field[:comment], false, "  (#{field[:type].ruby_description}) ", "  "
            end
          end
        end

        @fields << { name: Name.new(["dummy"]), type: PrimitiveType.new(:char_s) } if @fields.empty?

        unless @oo_functions.empty?
          writer.puts "module #{ruby_name}Wrappers"
          writer.indent do
            @oo_functions.each_with_index do |(name, function), index|
              parameter_names = function.parameters[1..-1].map { |parameter| parameter[:name].to_ruby_downcase }
              writer.puts "" unless index == 0
              writer.comment do
                function.parameters[1..-1].each do |parameter|
                  writer.write_description parameter[:description], false, "@param [#{parameter[:type].ruby_description}] #{parameter[:name].to_ruby_downcase} ", "  "
                end
                return_type = function.return_type.is_a?(StructOrUnion) ? function.return_type.ruby_name : function.return_type.ruby_description
                writer.write_description function.return_value_description, false, "@return [#{return_type}] ", "  "
              end
              writer.puts "def #{name.to_ruby_downcase}(#{parameter_names.join(', ')})"
              writer.indent do
                cast = function.return_type.is_a?(StructOrUnion) ? "#{function.return_type.ruby_name}.new " : ""
                writer.puts "#{cast}#{@generator.module_name}.#{function.ruby_name}(#{(["self"] + parameter_names).join(', ')})"
              end
              writer.puts "end"
            end
          end
          writer.puts "end", ""
        end

        writer.puts "class #{ruby_name} < #{@is_union ? 'FFI::Union' : 'FFI::Struct'}"
        writer.indent do
          writer.puts "include #{ruby_name}Wrappers" unless @oo_functions.empty?
          writer.write_array @fields, ",", "layout ", "       " do |field|
            ":#{field[:name].to_ruby_downcase}, #{field[:type].ruby_ffi_type}"
          end
        end
        writer.puts "end", ""

        @written = true
      end

      def ruby_name
        @ruby_name ||= @name.to_ruby_classname
      end

      def ruby_ffi_type
        @written ? ruby_name : ":pointer"
      end

      def ruby_description
        @written ? ruby_name : "FFI::Pointer(*#{ruby_name})"
      end

    end
  end
end
