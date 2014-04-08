require 'spec_helper'

describe MrDarcy::Promise::State::Rejected do
  let(:initial_state) { :unresolved }
  let(:stateful)      { Struct.new(:state).new initial_state }
  let(:state)         { described_class.new stateful }

  subject { state }

  it { should be_a MrDarcy::Promise::State::Base }
  its(:rejected?) { should be_true }
end
