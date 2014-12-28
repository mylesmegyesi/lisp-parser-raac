class Lisp::Parser
macro
  BLANK     [\ \t]+
  DIGIT     \d+
  ADD       \+
  SUBTRACT  \-
  MULTIPLY  \*
  DIVIDE    \/

rule
  {BLANK}      # no action
  {DIGIT}      { [:DIGIT, text] }
  {ADD}        { [:ADD, text] }
  {SUBTRACT}   { [:SUBTRACT, text] }
  {MULTIPLY}   { [:MULTIPLY, text] }
  {DIVIDE}     { [:DIVIDE, text] }
end
