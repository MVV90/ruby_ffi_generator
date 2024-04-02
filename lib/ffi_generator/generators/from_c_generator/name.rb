module FFIGenerate
  class Generator
    class Name

      attr_reader :parts, :raw

      RUBY_KEYWORDS = %w{alias and begin break case class def defined do else elsif end ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield BEGIN END}

      def initialize(parts, raw = nil)
        @parts = parts
        @raw = raw
      end

      def format(*modes, keyword_blacklist)
        parts = @parts.dup
        parts.map!(&:downcase) if modes.include?(:downcase)
        parts.map!(&:upcase) if modes.include?(:upcase)
        parts.map! { |s| s[0].upcase + s[1..-1] } if modes.include?(:camelcase)
        parts[0] = parts[0][0].downcase + parts[0][1..-1] if modes.include?(:initial_downcase)
        str = parts.join(modes.include?(:underscores) ? "_" : "")
        str.sub!(/^\d/, '_\0') # fix illegal beginnings
        str = "#{str}_" if keyword_blacklist.include?(str)
        str
      end

      def to_ruby_downcase
        format :downcase, :underscores, RUBY_KEYWORDS
      end

      def to_ruby_classname
        format :camelcase, RUBY_KEYWORDS
      end

      def to_ruby_constant
        format :upcase, :underscores, RUBY_KEYWORDS
      end

    end
  end
end
