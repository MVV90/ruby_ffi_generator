module FFIGenerate
  class Generator
    class Enum < Type

      attr_accessor :name, :writer

      def initialize(generator, name, constants, description)
        @generator = generator
        @writer = generator.writer
        @name = name
        @constants = constants
        @description = description
      end

      def shorten_names
        return if @constants.size < 2
        names = @constants.map { |constant| constant[:name].parts }
        names.each(&:shift) while names.map(&:first).uniq.size == 1 && @name.parts.map(&:downcase).include?(names.first.first.downcase)
        names.each(&:pop) while names.map(&:last).uniq.size == 1 && @name.parts.map(&:downcase).include?(names.first.last.downcase)
      end

      def write_ruby
        return if @name.nil?
        shorten_names

        @constants.each do |constant|
          constant[:symbol] = ":#{constant[:name].to_ruby_downcase}"
        end

        writer.comment do
          writer.write_description @description
          writer.puts "", "<em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:#{ruby_name}).</em>"
          writer.puts "", "=== Options:"
          @constants.each do |constant|
            writer.puts "#{constant[:symbol]} ::"
            writer.write_description constant[:comment], false, "  ", "  "
          end
          writer.puts "", "@method _enum_#{ruby_name}_", "@return [Symbol]", "@scope class"
        end

        writer.puts "enum :#{ruby_name}, ["
        writer.indent do
          writer.write_array @constants, "," do |constant|
            "#{constant[:symbol]}, #{constant[:value]}"
          end
        end
        writer.puts "]", ""
      end

      def ruby_name
        @ruby_name ||= @name.to_ruby_downcase
      end

      def ruby_ffi_type
        ":#{ruby_name}"
      end

      def ruby_description
        "Symbol from _enum_#{ruby_name}_"
      end

    end
  end
end
