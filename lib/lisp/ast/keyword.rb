module Lisp
  module AST
    class Keyword
      attr_reader :value

      def initialize(options)
        @value = options[:value]
        @options = options
      end
    end
  end
end
