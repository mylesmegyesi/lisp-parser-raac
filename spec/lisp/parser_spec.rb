require 'spec_helper'
require 'lisp/parser'

RSpec.describe Lisp::Parser do
  VALID_STARTING_SYMBOL_CHARACTERS = ('a'..'z').to_a + ('A'..'Z').to_a + %w(/ * ! _ ? $ % & = < >).to_a
  VALID_TRAILING_SYMBOL_CHARACTERS = VALID_STARTING_SYMBOL_CHARACTERS + (0..9).map(&:to_s) + %w(+ - . : #).to_a

  def parse_string(string)
    described_class.new.parse_string(string)
  end

  describe 'parsing integers' do
    it 'parses an integer' do
      result = parse_string('1')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('1')
    end

    it 'parses an integer with multiple digits' do
      result = parse_string('123')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('123')
    end

    it 'parses an integer with a leading zero' do
      result = parse_string('01')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('01')
    end

    it 'parses an integer with multiple leading zeros' do
      result = parse_string('001')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('001')
    end

    it 'parses an integer with a leading positive sign' do
      result = parse_string('+1')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('1')
      expect(result.sign).to eq('+')
    end

    it 'parses an integer with a leading negative sign' do
      result = parse_string('-1')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('1')
      expect(result.sign).to eq('-')
    end

    specify 'an integer without a sign has nil sign' do
      result = parse_string('1')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('1')
      expect(result.sign).to be_nil
    end
  end

  describe 'parsing floats' do
    it 'parses a float' do
      result = parse_string('1.0')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
    end

    it 'parses a float with multiple integer part digits' do
      result = parse_string('152.0')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.integer_part).to eq('152')
      expect(result.decimal_part).to eq('0')
    end

    it 'parses a float with multiple decimal part digits' do
      result = parse_string('1.152')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('152')
    end

    it 'parses a float with multiple trailing zeros' do
      result = parse_string('1.152000')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('152000')
    end

    it 'parses a float with a leading positive sign' do
      result = parse_string('+1.0')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to eq('+')
    end

    it 'parses a float with a leading negative sign' do
      result = parse_string('-1.0')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to eq('-')
    end

    specify 'a float without a leading sign has nil sign' do
      result = parse_string('1.0')

      expect(result.sign).to be_nil
    end

    it 'parses a float with a lowercase exponent' do
      result = parse_string('1.0e1')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('e')
      expect(result.exponent_part).to eq('1')
    end

    it 'parses a float with a lowercase exponent with multiple digits' do
      result = parse_string('1.0e123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.exponent_label).to eq('e')
      expect(result.exponent_part).to eq('123')
    end

    it 'parses a signed float with a lowercase exponent' do
      result = parse_string('+1.0e123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to eq('+')
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('e')
      expect(result.exponent_part).to eq('123')
    end

    it 'parses a float with a uppercase exponent' do
      result = parse_string('1.0E1')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('E')
      expect(result.exponent_part).to eq('1')
    end

    it 'parses a float with a positive signed exponent' do
      result = parse_string('1.0e+123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('e')
      expect(result.exponent_sign).to eq('+')
      expect(result.exponent_part).to eq('123')
    end

    it 'parses a float with a negative signed exponent' do
      result = parse_string('1.0e-123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('e')
      expect(result.exponent_sign).to eq('-')
      expect(result.exponent_part).to eq('123')
    end

    it 'parses a float with a positive signed uppercase exponent' do
      result = parse_string('1.0E+123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('E')
      expect(result.exponent_sign).to eq('+')
      expect(result.exponent_part).to eq('123')
    end

    it 'parses a float with a negative signed uppercase exponent' do
      result = parse_string('1.0E-123')

      expect(result).to be_a(Lisp::AST::Float)
      expect(result.sign).to be_nil
      expect(result.integer_part).to eq('1')
      expect(result.decimal_part).to eq('0')
      expect(result.exponent_label).to eq('E')
      expect(result.exponent_sign).to eq('-')
      expect(result.exponent_part).to eq('123')
    end
  end

  describe 'parsing symbols' do
    describe 'what the first character of a symbol can be' do
      specify "symbols can start with #{VALID_STARTING_SYMBOL_CHARACTERS.join(' ')}" do
        VALID_STARTING_SYMBOL_CHARACTERS.each do |valid_starting_character|
          symbol = "#{valid_starting_character}abc"
          result = parse_string(symbol)

          expect(result).to be_a(Lisp::AST::Symbol)
          expect(result.value).to eq(symbol)
        end
      end

      specify 'any valid starting character is also parsed as a symbol when no trailing characters are provided' do
        VALID_STARTING_SYMBOL_CHARACTERS.each do |valid_starting_character|
          result = parse_string(valid_starting_character)

          expect(result).to be_a(Lisp::AST::Symbol)
          expect(result.value).to eq(valid_starting_character)
        end
      end

      %w(+ - .).each do |number_prefix_character|
        describe "when the symbol starts with #{number_prefix_character}" do
          it "must be followed with a non-digit character, because #{number_prefix_character}9 could also be parsed as a number" do
            symbol = "#{number_prefix_character}a"
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end

          it 'can be followed by many non-digit characters' do
            symbol = "#{number_prefix_character}abc"
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end

          it 'can be followed a non-digit then any valid symbol character' do
            symbol = "#{number_prefix_character}a9"
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end

          it 'can be followed by itself' do
            symbol = number_prefix_character * 3
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end
        end
      end
    end

    describe 'what the trailing (after the first) characters in a symbol can be' do
      specify "symbols can include #{VALID_TRAILING_SYMBOL_CHARACTERS.join(' ')}" do
        VALID_TRAILING_SYMBOL_CHARACTERS.each do |valid_trailing_character|
          symbol = "a#{valid_trailing_character}"
          result = parse_string(symbol)

          expect(result).to be_a(Lisp::AST::Symbol)
          expect(result.value).to eq(symbol)
        end
      end

      specify 'any valid starting symbol can be paired with any valid trailing symbol' do
        VALID_STARTING_SYMBOL_CHARACTERS.each do |valid_starting_character|
          VALID_TRAILING_SYMBOL_CHARACTERS.each do |valid_trailing_character|
            symbol = valid_starting_character + valid_trailing_character
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end
        end
      end
    end
  end

  describe 'parsing strings' do
    specify 'parses one or more characters wraped in double quotes' do
      result = parse_string('"abc"')

      expect(result).to be_a(Lisp::AST::String)
      expect(result.value).to eq('abc')
    end

    specify 'strings can include escaped double quotes' do
      result = parse_string('"abc\"abc\"abc"')

      expect(result).to be_a(Lisp::AST::String)
      expect(result.value).to eq('abc\"abc\"abc')
    end
  end

  describe 'parsing booleans' do
    specify 'parses true' do
      result = parse_string('true')

      expect(result).to be_a(Lisp::AST::Boolean)
      expect(result.value).to eq('true')
    end

    specify 'parses false' do
      result = parse_string('false')

      expect(result).to be_a(Lisp::AST::Boolean)
      expect(result.value).to eq('false')
    end
  end

  describe 'parsing keywords' do
    specify 'keywords start with colon (:)' do
      keyword = ':abc'
      result = parse_string(keyword)

      expect(result).to be_a(Lisp::AST::Keyword)
      expect(result.value).to eq(keyword)
    end

    specify 'keywords can include any valid symbol character' do
      VALID_TRAILING_SYMBOL_CHARACTERS.each do |valid_symbol_character|
        keyword = ":#{valid_symbol_character}#{valid_symbol_character}"
        result = parse_string(keyword)

        expect(result).to be_a(Lisp::AST::Keyword)
        expect(result.value).to eq(keyword)
      end
    end
  end

  describe 'parsing lists' do
    specify 'a list is group of expressions wraped in parentheses' do
      expression = '(1 2 3)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('2')
      expect(values[2]).to be_a(Lisp::AST::Integer)
      expect(values[2].value).to eq('3')
    end

    specify 'a list can be empty' do
      result = parse_string('()')

      expect(result).to be_a(Lisp::AST::List)
      expect(result.values).to be_empty
    end

    specify 'a list can contain a float' do
      expression = '(1.0)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Float)
      expect(values[0].integer_part).to eq('1')
      expect(values[0].decimal_part).to eq('0')
    end

    specify 'a list can contain an integer' do
      expression = '(1)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
    end

    specify 'a list can contain a keyword' do
      expression = '(:my-key)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':my-key')
    end

    specify 'a list can contain a string' do
      expression = '("my string")'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::String)
      expect(values[0].value).to eq('my string')
    end

    specify 'a list can contain a symbol' do
      expression = '(my-symbol)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'a list can contain a vector' do
      expression = "([1])"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Vector)
      values = values[0].values
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
    end

    specify 'a list can contain lists' do
      expression = "(1 2 (3 4 (:five :six (:seven))))"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('2')
      expect(values[2]).to be_a(Lisp::AST::List)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('3')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('4')
      expect(values[2]).to be_a(Lisp::AST::List)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':five')
      expect(values[1]).to be_a(Lisp::AST::Keyword)
      expect(values[1].value).to eq(':six')
      expect(values[2]).to be_a(Lisp::AST::List)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':seven')
    end

    specify 'there can be one or more spaces between the left parenthesis' do
      expression = '(   my-symbol)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more newlines between the left parenthesis' do
      expression = "(\n\nmy-symbol)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more tabs between the left parenthesis' do
      expression = "(\t\tmy-symbol)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more spaces between the right parenthesis' do
      expression = '(my-symbol   )'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more newlines between the right parenthesis' do
      expression = "(my-symbol\n\n)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more tabs between the right parenthesis' do
      expression = "(my-symbol\t\t)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more spaces between elements' do
      expression = '(my-symbol   other-symbol)'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more newlines between elements' do
      expression = "(my-symbol\n\nother-symbol)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more tabs between elements' do
      expression = "(my-symbol\t\tother-symbol)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more commas between elements' do
      expression = "(my-symbol,,,other-symbol)"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'all the whitespace together' do
      expression = "( \n\t my-symbol ,\n\t\n,other-symbol\n\t abc\n\t )"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::List)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
      expect(values[2]).to be_a(Lisp::AST::Symbol)
      expect(values[2].value).to eq('abc')
    end
  end

  describe 'parsing vectors' do
    specify 'a vector is group of expressions wraped in parentheses' do
      expression = '[1 2 3]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('2')
      expect(values[2]).to be_a(Lisp::AST::Integer)
      expect(values[2].value).to eq('3')
    end

    specify 'a vector can be empty' do
      result = parse_string('[]')

      expect(result).to be_a(Lisp::AST::Vector)
      expect(result.values).to be_empty
    end

    specify 'a vector can contain a float' do
      expression = '[1.0]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Float)
      expect(values[0].integer_part).to eq('1')
      expect(values[0].decimal_part).to eq('0')
    end

    specify 'a vector can contain an integer' do
      expression = '[1]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
    end

    specify 'a vector can contain a keyword' do
      expression = '[:my-key]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':my-key')
    end

    specify 'a vector can contain a string' do
      expression = '["my string"]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::String)
      expect(values[0].value).to eq('my string')
    end

    specify 'a vector can contain a symbol' do
      expression = '[my-symbol]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'a vector can contain a list' do
      expression = "[(1)]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::List)
      values = values[0].values
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
    end

    specify 'a vector can contain vectors' do
      expression = "[1 2 [3 4 [:five :six [:seven]]]]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('1')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('2')
      expect(values[2]).to be_a(Lisp::AST::Vector)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Integer)
      expect(values[0].value).to eq('3')
      expect(values[1]).to be_a(Lisp::AST::Integer)
      expect(values[1].value).to eq('4')
      expect(values[2]).to be_a(Lisp::AST::Vector)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':five')
      expect(values[1]).to be_a(Lisp::AST::Keyword)
      expect(values[1].value).to eq(':six')
      expect(values[2]).to be_a(Lisp::AST::Vector)
      values = values[2].values
      expect(values[0]).to be_a(Lisp::AST::Keyword)
      expect(values[0].value).to eq(':seven')
    end

    specify 'there can be one or more spaces between the left bracket' do
      expression = '[   my-symbol]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more newlines between the left bracket' do
      expression = "[\n\nmy-symbol]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more tabs between the left bracket' do
      expression = "[\t\tmy-symbol]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more spaces between the right bracket' do
      expression = '[my-symbol   ]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more newlines between the right bracket' do
      expression = "[my-symbol\n\n]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more tabs between the right bracket' do
      expression = "[my-symbol\t\t]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(1)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
    end

    specify 'there can be one or more spaces between elements' do
      expression = '[my-symbol   other-symbol]'
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more newlines between elements' do
      expression = "[my-symbol\n\nother-symbol]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more tabs between elements' do
      expression = "[my-symbol\t\tother-symbol]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'there can be one or more commas between elements' do
      expression = "[my-symbol,,,other-symbol]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(2)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
    end

    specify 'all the whitespace together' do
      expression = "[ \n\t my-symbol ,\n\t\n,other-symbol\n\t abc\n\t ]"
      result = parse_string(expression)

      expect(result).to be_a(Lisp::AST::Vector)
      values = result.values
      expect(values.size).to eq(3)
      expect(values[0]).to be_a(Lisp::AST::Symbol)
      expect(values[0].value).to eq('my-symbol')
      expect(values[1]).to be_a(Lisp::AST::Symbol)
      expect(values[1].value).to eq('other-symbol')
      expect(values[2]).to be_a(Lisp::AST::Symbol)
      expect(values[2].value).to eq('abc')
    end
  end
end
