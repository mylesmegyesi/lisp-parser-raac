class Lisp::Parser
rule
  expression:
      integer
    | float

  integer:
      digits { return Lisp::AST::Integer.new(value: val[0]) }
    | sign digits { return Lisp::AST::Integer.new(sign: val[0], value: val[1]) }

  float:
      integer decimal { return Lisp::AST::Float.new(sign: val[0].sign, integer_part: val[0].value, decimal_part: val[1]) }
    | integer decimal exponent { return Lisp::AST::Float.new(sign: val[0].sign, integer_part: val[0].value, decimal_part: val[1], exponent_label: val[2].label, exponent_sign: val[2].sign, exponent_part: val[2].value) }

  decimal: point digits { return val[1] }

  exponent:
      EXPONENT digits { return Lisp::AST::Exponent.new(label: val[0], value: val[1]) }
    | EXPONENT sign digits { return Lisp::AST::Exponent.new(label: val[0], sign: val[1], value: val[2]) }

  digits:
      DIGIT
    | DIGIT digits { return val.join('') }

  sign: '+' | '-'

  point: '.'
end

---- header
  require 'lisp/ast/integer'
  require 'lisp/ast/float'
  require 'lisp/ast/exponent'

---- inner
  def parse_string(string)
    scan_str(string)
  end

---- footer
  require 'lisp/lexer'
