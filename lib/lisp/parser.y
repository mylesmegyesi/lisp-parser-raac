class Lisp::Parser
rule
  expression
    :
        integer
      | float

  integer : unsigned_integer | signed_integer

  unsigned_integer
    : DIGITS { return Lisp::AST::Integer.from_value(val[0]) }

  signed_integer
    :
        PLUS unsigned_integer { return val[1].with_positive_sign }
      | MINUS unsigned_integer { return val[1].with_negative_sign }

  float : unsigned_float | signed_float

  unsigned_float
    : DIGITS DOT DIGITS { return Lisp::AST::Float.from_integer_and_decimal(val[0], val[2]) }

  signed_float
    :
        PLUS unsigned_float { return val[1].with_positive_sign }
      | MINUS unsigned_float { return val[1].with_negative_sign }
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
