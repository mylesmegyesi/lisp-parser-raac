class Lisp::Parser
macro
  DIGIT \d
  DOT \.
  SIGN \+|\-
  EXPONENT e|E

rule
  {DIGIT} { [:DIGIT, text] }
  {DOT} { [text, text] }
  {EXPONENT} { [:EXPONENT, text] }
  {SIGN} { [text, text] }
end
