require 'spec_helper'

describe MrDarcy::Promise::State::Base do
  let(:initial_state) { 'unresolved'}
  let(:stateful)      { Struct.new(:state).new initial_state }
  let(:state)         { described_class.new stateful }
  subject { state }

  it { should respond_to :unresolved? }
  it { should respond_to :resolved? }
  it { should respond_to :rejected? }

  describe '#resolve' do
    subject { -> { state.resolve } }
    it { should raise_error }
  end

  describe '#reject' do
    subject { -> { state.reject } }
    it { should raise_error }
  end
end
