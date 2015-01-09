require 'spec_helper'
require 'lisp/parser'

RSpec.describe Lisp::Parser do

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
    valid_starting_characters = ('a'..'z').to_a + ('A'..'Z').to_a + %w(/ * ! _ ? $ % & = < >).to_a
    valid_trailing_characters = valid_starting_characters + (0..9).map(&:to_s) + %w(+ - . : #).to_a

    describe 'what the first character of a symbol can be' do
      specify "symbols can start with #{valid_starting_characters.join(' ')}" do
        valid_starting_characters.each do |valid_starting_character|
          symbol = "#{valid_starting_character}abc"
          result = parse_string(symbol)

          expect(result).to be_a(Lisp::AST::Symbol)
          expect(result.value).to eq(symbol)
        end
      end

      specify 'any valid starting character is also parsed as a symbol when no trailing characters are provided' do
        valid_starting_characters.each do |valid_starting_character|
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
      specify "symbols can include #{valid_trailing_characters.join(' ')}" do
        valid_trailing_characters.each do |valid_trailing_character|
          symbol = "a#{valid_trailing_character}"
          result = parse_string(symbol)

          expect(result).to be_a(Lisp::AST::Symbol)
          expect(result.value).to eq(symbol)
        end
      end

      specify 'any valid starting symbol can be paired with any valid trailing symbol' do
        valid_starting_characters.each do |valid_starting_character|
          valid_trailing_characters.each do |valid_trailing_character|
            symbol = valid_starting_character + valid_trailing_character
            result = parse_string(symbol)

            expect(result).to be_a(Lisp::AST::Symbol)
            expect(result.value).to eq(symbol)
          end
        end
      end
    end
  end

end
