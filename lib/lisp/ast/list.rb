module Lisp
  module AST
    class List
      attr_reader :values

      def initialize(options)
        @values = options[:values]
        @options = options
      end
    end
  end
end
