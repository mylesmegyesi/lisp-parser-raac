require 'lisp/parser'

describe Lisp::Parser do

  it 'parses a number' do
    parser = described_class.new
    result = parser.scan_str('1')

    expect(result).to be_a(Lisp::AST::Integer)
    expect(result.value).to eq('1')
  end

end
