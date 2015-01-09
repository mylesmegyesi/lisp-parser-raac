module Lisp
  module AST
    class Exponent
      attr_reader :label, :sign, :value

      def initialize(options)
        @label = options[:label]
        @sign = options[:sign]
        @value = options[:value]
        @options = options
      end

    end
  end
end
