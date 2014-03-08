require 'spec_helper'

describe MrDarcy::PromiseDSL do

  let(:promise) { double :promise }
  let(:dsl)     { described_class.new(promise) }
  subject       { dsl }

  it { should respond_to :resolve }
  it { should respond_to :reject }
  it { should respond_to :promise }

  describe '.new' do
    its(:promise) { should eq promise }
  end

  describe '#resolve' do
    subject { dsl.resolve :resolved_value }
    before  { promise.stub :value= => nil, resolve!: nil }

    it 'resolves the promise' do
      promise.should_receive :resolve!
      subject
    end

    it 'stores the value'  do
      promise.should_receive(:value=).with(:resolved_value)
      subject
    end
  end

  describe '#reject' do
    subject { dsl.reject :exception }
    before  { promise.stub :value= => nil, reject!: nil }

    it 'rejects the promise' do
      promise.should_receive :reject!
      subject
    end

    it 'stores the value' do
      promise.should_receive(:value=).with(:exception)
      subject
    end
  end

end
