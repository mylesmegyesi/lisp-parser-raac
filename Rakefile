require 'bundler/gem_tasks'

desc 'Generate Parser'
task :parser do
  sh 'racc lib/lisp/parser.y -o lib/lisp/parser.rb'
end

desc 'Generate Lexer'
task :lexer do
  sh 'rex lib/lisp/lexer.rex -o lib/lisp/lexer.rb'
end

desc 'Generate Lexer and Parser'
task :generate => [:lexer, :parser]
