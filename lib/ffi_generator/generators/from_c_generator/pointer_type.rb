module FFIGenerate
  class Generator
    class PointerType < Type

      attr_reader :pointee_name, :depth

      def initialize(pointee_name, depth)
        @pointee_name = pointee_name
        @depth = depth
      end

      def name
        @pointee_name
      end

      def ruby_name
        @pointee_name.to_ruby_downcase
      end

      def ruby_ffi_type
        ":pointer"
      end

      def ruby_description
        "FFI::Pointer(#{'*' * @depth}#{@pointee_name ? @pointee_name.to_ruby_classname : ''})"
      end

    end
  end
end
