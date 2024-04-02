module FFIGenerate
  class Generator
    class Define

      attr_accessor :writer

      def initialize(generator, name, parameters, value)
        @generator = generator
        @writer = generator.writer
        @name = name
        @parameters = parameters
        @value = value
      end

      def write_ruby
        parts = @value.map do |v|
          if v.is_a?(Array)
            case v[0]
            when :method then v[1].to_ruby_downcase
            when :constant then v[1].to_ruby_constant
            else raise ArgumentError
            end
          else
            v
          end
        end
        if @parameters
          writer.puts "def #{@name.to_ruby_downcase}(#{@parameters.join(", ")})"
          writer.indent do
            writer.puts parts.join
          end
          writer.puts "end", ""
        else
          writer.puts "#{@name.to_ruby_constant} = #{parts.join}", ""
        end
      end

    end
  end
end
