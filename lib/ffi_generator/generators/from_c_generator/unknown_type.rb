module FFIGenerate
  class Generator
    class UnknownType < Type

      def name
        Name.new(["unknown"])
      end

      def ruby_name
        "error_unknown"
      end

      def ruby_ffi_type
        ":char"
      end

    end
  end
end
