module Lisp
  module AST
    class Float

      attr_reader :integer_part, :decimal_part

      def initialize(integer_part, decimal_part)
        @integer_part = integer_part
        @decimal_part = decimal_part
      end

    end
  end
end
