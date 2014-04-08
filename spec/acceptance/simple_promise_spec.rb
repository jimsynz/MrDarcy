require 'spec_helper'

describe "Simple promise" do

  MrDarcy.all_drivers.each do |driver|
    describe "with driver #{driver}" do
      let(:promise) { MrDarcy::Promise.new(driver: driver, &promise_block) }
      subject { promise }

      When 'the promise resolves' do
        let(:promise_block) { proc { |p| p.resolve 1 } }

        it_should_behave_like 'a resolved promise'
        its(:result) { should eq 1 }
      end

      When 'the promise rejects' do
        let(:promise_block) { proc { |p| p.reject 1 } }

        it_should_behave_like 'a rejected promise'
        its(:result) { should eq 1 }
      end
    end
  end
end
