class Lisp::Parser
macro
  DIGITS    \d+
  DOT       \.

rule
  {DIGITS}      { [:DIGITS, text] }
  {DOT}         { [:DOT, text] }
end
