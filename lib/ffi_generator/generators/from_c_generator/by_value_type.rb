module FFIGenerate
  class Generator
    class ByValueType < Type

      def initialize(inner_type)
        @inner_type = inner_type
      end

      def name
        @inner_type.name
      end

      def ruby_name
        @inner_type.ruby_name
      end

      def ruby_ffi_type
        "#{@inner_type.ruby_ffi_type}.by_value"
      end

    end
  end
end
