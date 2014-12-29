module Lisp
  module AST
    class Integer

      attr_reader :value

      def self.from_value(value)
        new({
          value: value,
          positive: true,
          signed: false
        })
      end

      def initialize(options)
        @value = options[:value]
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
