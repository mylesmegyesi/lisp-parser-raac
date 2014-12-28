module Lisp
  module AST
    class Integer

      attr_reader :value

      def initialize(value)
        @value = value
      end

    end
  end
end
