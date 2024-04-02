module FFIGenerate
  class Generator
    class FunctionOrCallback < Type

      attr_reader :name, :parameters, :return_type, :function_description, :return_value_description

      attr_accessor :writer, :failed_clang_parse_metadata

      def initialize(generator, name, parameters, return_type, is_callback, blocking, function_description, return_value_description)
        @generator = generator
        @writer = generator.writer
        @name = name
        @parameters = parameters
        @return_type = return_type
        @is_callback = is_callback
        @blocking = blocking
        @function_description = function_description
        @return_value_description = return_value_description
        @failed_clang_parse_metadata = false
      end

      def write_ruby
        writer.puts "@blocking = true" if @blocking
        writer.comment do
          writer.write_description @function_description
          writer.puts "", "<em>This entry is only for documentation and no real method.</em>" if @is_callback
          writer.puts "", "@method #{@is_callback ? "_callback_#{ruby_name}_" : ruby_name}(#{@parameters.map{ |parameter| parameter[:name].to_ruby_downcase }.join(', ')})"
          @parameters.each do |parameter|
            writer.write_description parameter[:description], false, "@param [#{parameter[:type].ruby_description}] #{parameter[:name].to_ruby_downcase} ", "  "
          end
          writer.write_description @return_value_description, false, "@return [#{@return_type.ruby_description}] ", "  "
          writer.puts "@scope class"
        end

        ffi_signature = "[#{@parameters.map{ |parameter| parameter[:type].ruby_ffi_type }.join(', ')}], #{@return_type.ruby_ffi_type}"

        if @is_callback
          write_callback(ruby_name, ffi_signature)
        else
          write_attach_function(ruby_name, ffi_signature)
        end
      end

      def write_callback(ruby_name, ffi_signature)
        writer.puts("callback :#{ruby_name}, #{ffi_signature}", "")
      end

      def write_attach_function(ruby_name, ffi_signature)
        if @failed_clang_parse_metadata
          pre_msg = "# FAILED FFI WRAPPER GENERATION --|"
          failed_msg = "#{pre_msg} #{ruby_name} - Error: Cannot attach_function for :#{@name.raw} with signature #{ffi_signature}"
          writer.puts failed_msg
          puts failed_msg

          @failed_clang_parse_metadata[:failed_reasons].each do |msg|
            failed_msg = "#{pre_msg} #{ruby_name} - Error: #{msg}"
            writer.puts failed_msg
            puts failed_msg
          end

        else
          writer.puts("attach_function :#{ruby_name}, :#{@name.raw}, #{ffi_signature}")
        end

        writer.puts
      end

      def ruby_name
        @ruby_name ||= @name.to_ruby_downcase
      end

      def ruby_ffi_type
        ":#{ruby_name}"
      end

      def ruby_description
        "Proc(_callback_#{ruby_name}_)"
      end

    end
  end
end
