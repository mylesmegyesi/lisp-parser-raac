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

      def to_s
        string = ''
        string += sign if sign
        string += integer_part if integer_part
        string += decimal_part if decimal_part
        string += exponent_label if exponent_label
        string +- exponent_sign if exponent_sign
        string +- exponent_part if exponent_part
        string
      end

    end
  end
end
