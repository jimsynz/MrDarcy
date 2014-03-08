require 'spec_helper'

describe MrDarcy::Promise do
  let(:block)   { proc {} }
  let(:promise) { described_class.new &block }
  subject { promise }
  describe '.new' do
    it 'takes a block' do
      expect { |b| described_class.new &b }.to yield_control
    end
  end

  When 'initially created' do
    its(:unresolved?) { should be_true }
  end

  When 'the promise resolves' do
    let(:block) do
      proc do
        resolve :it_works
      end
    end

    its(:resolved?) { should be_true }
    its(:rejected?) { should be_false }
    its(:value)     { should eq :it_works }
  end

  When 'the promise rejects' do
    let(:block) do
      proc do
        reject :it_rejects
      end
    end

    its(:rejected?) { should be_true }
    its(:resolved?) { should be_false }
    its(:value)     { should eq :it_rejects }
  end
end
