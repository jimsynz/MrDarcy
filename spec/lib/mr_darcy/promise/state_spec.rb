require 'spec_helper'

describe MrDarcy::Promise::State do
  describe '#state' do
    let(:stateful) { Struct.new(:state).new initial_state }
    subject { MrDarcy::Promise::State.state stateful }

    When 'the state is unresolved' do
      let(:initial_state) { :unresolved }
      it { should be_an MrDarcy::Promise::State::Unresolved }
    end

    When 'the state is resolved' do
      let(:initial_state) { :resolved }
      it { should be_an MrDarcy::Promise::State::Resolved }
    end

    When 'the state is rejected' do
      let(:initial_state) { :rejected }
      it { should be_an MrDarcy::Promise::State::Rejected }
    end

    Otherwise do
      let(:initial_state) { :foo }
      it 'raises an exception' do
        expect { subject }.to raise_error
      end
    end
  end
end
