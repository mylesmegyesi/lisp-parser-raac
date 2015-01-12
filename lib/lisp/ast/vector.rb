module Lisp
  module AST
    class Vector
      attr_reader :values

      def initialize(options)
        @values = options[:values]
        @options = options
      end
    end
  end
end
