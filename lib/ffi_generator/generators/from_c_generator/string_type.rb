module FFIGenerate
  class Generator
    class StringType < Type

      def name
        Name.new(["string"])
      end

      def ruby_name
        "String"
      end

      def ruby_ffi_type
        ":string"
      end

    end
  end
end
