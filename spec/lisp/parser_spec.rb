require 'spec_helper'
require 'lisp/parser'

RSpec.describe Lisp::Parser do

  def parse_string(string)
    described_class.new.parse_string(string)
  end

  context 'integers' do
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

  context 'floats' do

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

end
