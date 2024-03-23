module FFIGenerate
  class Generator
    class FunctionOrCallback < Type

      attr_reader :name, :parameters, :return_type, :function_description, :return_value_description

      attr_accessor :failed_clang_parse

      def initialize(generator, name, parameters, return_type, is_callback, blocking, function_description, return_value_description)
        @generator = generator
        @name = name
        @parameters = parameters
        @return_type = return_type
        @is_callback = is_callback
        @blocking = blocking
        @function_description = function_description
        @return_value_description = return_value_description
        @failed_clang_parse = false
      end

    end
  end
end
