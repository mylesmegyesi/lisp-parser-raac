class Lisp::Parser
rule
  expression
    :   DIGIT                 { return Lisp::AST::Integer.new(val[0]) }
      | DIGIT ADD DIGIT       { return val[0] + val[2] }
      | DIGIT SUBTRACT DIGIT  { return val[0] - val[2] }
      | DIGIT MULTIPLY DIGIT  { return val[0] * val[2] }
      | DIGIT DIVIDE DIGIT    { return val[0] / val[2] }
end

---- header
  require 'lisp/ast/integer'

---- footer
  require 'lisp/lexer'
