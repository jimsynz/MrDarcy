require 'spec_helper'

describe MrDarcy::Promise::Synchronous do
  let(:sync) { described_class.new proc {} }
  subject { sync }

  it { should respond_to :result }
  it { should respond_to :final }

  describe '#schedule_promise' do
    it 'yields immediately' do
      expect { |b| sync.send(:schedule_promise, &b) }.to yield_control.once
    end
  end

  describe '#generate_child_promise' do
    it 'creates a child promise with the correct driver' do
      expect(sync.send(:generate_child_promise).promise).to be_a described_class
    end
  end
end
