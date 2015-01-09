module Lisp
  module AST
    class Integer

      attr_reader :sign, :value

      def initialize(options)
        @sign = options[:sign]
        @value = options[:value]
        @options = options
      end

    end
  end
end
