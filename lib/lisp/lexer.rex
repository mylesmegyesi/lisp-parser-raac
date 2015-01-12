class Lisp::Parser
macro
  BOOLEAN true|false
  STRING "([^"]|\")*"
  LPAREN \(({WHITESPACE})*
  RPAREN ({WHITESPACE})*\)
  WHITESPACE [\ \n\t]
  ANYTHING .

rule
  {BOOLEAN}    { [:BOOLEAN, text] }
  {STRING}     { [:STRING, text] }
  {LPAREN}     { [:LPAREN, text] }
  {RPAREN}     { [:RPAREN, text] }
  {WHITESPACE} { [:WHITESPACE, text] }
  {ANYTHING}   { [text, text] }
end
