module FFIGenerate
  class Generator
    class ArrayType < Type

      def initialize(element_type, constant_size)
        @element_type = element_type
        @constant_size = constant_size
      end

      def name
        Name.new(["array"])
      end

      def ruby_name
        "array"
      end

      def ruby_ffi_type
        if @constant_size
          "[#{@element_type.ruby_ffi_type}, #{@constant_size}]"
        else
          ":pointer"
        end
      end

      def ruby_description
        "Array<#{@element_type.ruby_description}>"
      end

    end
  end
end
