module Lisp
  module AST
    class Float

      attr_reader :sign, :integer_part, :decimal_part, :exponent_label, :exponent_sign, :exponent_part

      def initialize(options)
        @sign = options[:sign]
        @integer_part = options[:integer_part]
        @decimal_part = options[:decimal_part]
        @exponent_label = options[:exponent_label]
        @exponent_sign = options[:exponent_sign]
        @exponent_part = options[:exponent_part]
        @options = options
      end

    end
  end
end
