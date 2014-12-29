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
      result = parse_string('12')

      expect(result).to be_a(Lisp::AST::Integer)
      expect(result.value).to eq('12')
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

  end

end
