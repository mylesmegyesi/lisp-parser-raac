class Lisp::Parser
macro
  DIGITS    \d+
  DOT       \.
  PLUS      \+
  MINUS     \-

rule
  {DIGITS}      { [:DIGITS, text] }
  {DOT}         { [:DOT, text] }
  {PLUS}        { [:PLUS, text] }
  {MINUS}       { [:MINUS, text] }
end
