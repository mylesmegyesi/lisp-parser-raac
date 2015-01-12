class Lisp::Parser
rule
  expression:
      boolean
    | float
    | integer
    | keyword
    | list
    | string
    | symbol
    | vector

  boolean: BOOLEAN { return Lisp::AST::Boolean.new(value: val[0]) }

  float:
      integer decimal { return Lisp::AST::Float.new(sign: val[0].sign, integer_part: val[0].value, decimal_part: val[1]) }
    | integer decimal exponent { return Lisp::AST::Float.new(sign: val[0].sign, integer_part: val[0].value, decimal_part: val[1], exponent_label: val[2].label, exponent_sign: val[2].sign, exponent_part: val[2].value) }

  integer:
      digits { return Lisp::AST::Integer.new(value: val[0]) }
    | sign digits { return Lisp::AST::Integer.new(sign: val[0], value: val[1]) }

  keyword: ':' trailing_symbol_characters { return Lisp::AST::Keyword.new(value: ":#{val[1]}") }

  list:
      LPAREN RPAREN { return Lisp::AST::List.new(values: []) }
    | LPAREN separated_expressions RPAREN { return Lisp::AST::List.new(values: val[1]) }

  string: STRING { return Lisp::AST::String.new(value: val[0][1..-2]) }

  symbol:
      leading_symbol_character { return Lisp::AST::Symbol.new(value: val[0]) }
    | leading_symbol_character trailing_symbol_characters { return Lisp::AST::Symbol.new(value: val.join('')) }
    | digit_prefix non_digit_trailing_symbol_character { return Lisp::AST::Symbol.new(value: val.join('')) }
    | digit_prefix non_digit_trailing_symbol_character trailing_symbol_characters { return Lisp::AST::Symbol.new(value: val.join('')) }

  vector:
      LBRACKET RBRACKET { return Lisp::AST::Vector.new(values: []) }
    | LBRACKET separated_expressions RBRACKET { return Lisp::AST::Vector.new(values: val[1]) }

  # fragments

  separated_expressions:
      expression { return [val[0]] }
    | expression expression_separators separated_expressions { return val[2].unshift(val[0]) }

  expression_separators: expression_separator | expression_separator expression_separators
  expression_separator: whitespace | ','

  whitespace: WHITESPACE

  digit_prefix: sign | point

  trailing_symbol_characters:
      trailing_symbol_character
    | trailing_symbol_character trailing_symbol_characters { return val.join('') }

  trailing_symbol_character: non_digit_trailing_symbol_character | digit

  non_digit_trailing_symbol_character: leading_symbol_character | '+' | '-' | '.' | ':' | '#'

  leading_symbol_character: alpha | '*' | '!' | '_' | '?' | '$' | '%' | '&' | '=' | '<' | '>' | '/'

  decimal: point digits { return val[1] }

  exponent:
      exp digits { return Lisp::AST::Exponent.new(label: val[0], value: val[1]) }
    | exp sign digits { return Lisp::AST::Exponent.new(label: val[0], sign: val[1], value: val[2]) }

  digits:
      digit
    | digit digits { return val.join('') }

  exp: 'e' | 'E'

  digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'

  sign: '+' | '-'

  point: '.'

  alpha:
      'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z'
    | 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z'
end

---- header
  require 'lisp/ast/boolean'
  require 'lisp/ast/exponent'
  require 'lisp/ast/float'
  require 'lisp/ast/integer'
  require 'lisp/ast/keyword'
  require 'lisp/ast/list'
  require 'lisp/ast/string'
  require 'lisp/ast/symbol'
  require 'lisp/ast/vector'

---- inner
  def parse_string(string)
    scan_str(string)
  end

---- footer
  require 'lisp/lexer'
