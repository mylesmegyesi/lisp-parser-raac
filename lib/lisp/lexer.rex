class Lisp::Parser
macro
  BOOLEAN true|false
  STRING "([^"]|\")*"
  ANYTHING .

rule
  {BOOLEAN} { [:BOOLEAN, text] }
  {STRING} { [:STRING, text] }
  {ANYTHING} { [text, text] }
end
