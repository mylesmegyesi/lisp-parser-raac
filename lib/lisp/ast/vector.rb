module Lisp
  module AST
    class Vector
      attr_reader :values

      def initialize(options)
        @values = options[:values]
        @options = options
      end

      def to_s
        presented_values = values.map(&:to_s).join(' ')
        "[#{presented_values}]"
      end
    end
  end
end
