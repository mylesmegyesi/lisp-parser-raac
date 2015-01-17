module Lisp
  module AST
    class Integer

      attr_reader :sign, :value

      def initialize(options)
        @sign = options[:sign]
        @value = options[:value]
        @options = options
      end

      def to_s
        string = ''
        string += sign if sign
        string += value if value
        string
      end

    end
  end
end
