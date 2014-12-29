class Lisp::Parser
rule
  expression
    :
        integer
      | float

  integer : DIGITS { return Lisp::AST::Integer.new(val[0]) }

  float
    : DIGITS DOT DIGITS { return Lisp::AST::Float.new(val[0], val[2]) }
end

---- header
  require 'lisp/ast/integer'
  require 'lisp/ast/float'

---- inner
  def parse_string(string)
    scan_str(string)
  end

---- footer
  require 'lisp/lexer'
