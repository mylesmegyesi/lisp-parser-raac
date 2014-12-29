module Lisp
  module AST
    class Float

      attr_reader :integer_part, :decimal_part

      def self.from_integer_and_decimal(integer_part, decimal_part)
        new({
          integer_part: integer_part,
          decimal_part: decimal_part,
          positive: true,
          signed: false
        })
      end

      def initialize(options)
        @integer_part = options[:integer_part]
        @decimal_part = options[:decimal_part]
        @positive = options[:positive]
        @signed = options[:signed]
        @options = options
      end

      def positive?
        @positive
      end

      def signed?
        @signed
      end

      def with_positive_sign
        self.class.new(@options.merge({
          positive: true,
          signed: true
        }))
      end

      def with_negative_sign
        self.class.new(@options.merge({
          positive: false,
          signed: true
        }))
      end

    end
  end
end
