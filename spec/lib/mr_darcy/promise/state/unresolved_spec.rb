require 'spec_helper'

describe MrDarcy::Promise::State::Unresolved do
  let(:initial_state) { :unresolved }
  let(:stateful)      { Struct.new(:state).new initial_state }
  let(:state)         { described_class.new stateful }

  subject { state }

  it { should be_a MrDarcy::Promise::State::Base }
  its(:unresolved?) { should be_true }

  describe '#resolve' do
    subject { -> { state.resolve } }
    it { should change { stateful.state }.from(:unresolved).to(:resolved) }
  end

  describe '#reject' do
    subject { -> { state.reject } }
    it { should change { stateful.state }.from(:unresolved).to(:rejected) }
  end
end
