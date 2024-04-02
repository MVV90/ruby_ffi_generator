module FFIGenerate
  class Generator
    class PrimitiveType < Type

      def initialize(clang_type)
        @clang_type = clang_type
      end

      def name
        Name.new([@clang_type.to_s])
      end

      def ruby_name
        case @clang_type
        when :void
          "nil"
        when :bool
          "Boolean"
        when :u_char, :u_short, :u_int, :u_long, :u_long_long, :char_s, :s_char, :short, :int, :long, :long_long
          "Integer"
        when :float, :double
          "Float"
        end
      end

      def ruby_ffi_type
        case @clang_type
        when :void            then ":void"
        when :bool            then ":bool"
        when :u_char          then ":uchar"
        when :u_short         then ":ushort"
        when :u_int           then ":uint"
        when :u_long          then ":ulong"
        when :u_long_long     then ":ulong_long"
        when :char_s, :s_char then ":char"
        when :short           then ":short"
        when :int             then ":int"
        when :long            then ":long"
        when :long_long       then ":long_long"
        when :float           then ":float"
        when :double          then ":double"
        end
      end

    end
  end
end
