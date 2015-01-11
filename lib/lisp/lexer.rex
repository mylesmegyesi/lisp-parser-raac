class Lisp::Parser
macro
  STRING "([^"]|\")*"
  ANYTHING .

rule
  {STRING} { [:STRING, text] }
  {ANYTHING} { [text, text] }
end
