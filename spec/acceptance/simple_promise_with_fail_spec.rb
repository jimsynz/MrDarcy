require 'spec_helper'

describe "Simple promise" do

  MrDarcy.all_drivers.each do |driver|
    describe "with driver #{driver}" do
      let(:promise) { MrDarcy::Promise.new(driver: driver, &promise_block).fail { |v| v+1 } }
      subject { promise }

      When 'the promise resolves' do
        let(:promise_block) { proc { |p| p.resolve 1 } }

        its(:result)  { should eq 1 }
        its(:final)   { should be_resolved }
        its(:final)   { should_not be_rejected }
        its(:final)   { should_not be_unresolved }
      end

      When 'the promise rejects' do
        let(:promise_block) { proc { |p| p.reject 1 } }

        its(:result)  { should eq 2 }
        its(:final)   { should be_resolved }
        its(:final)   { should_not be_rejected }
        its(:final)   { should_not be_unresolved }
      end
    end
  end
end
