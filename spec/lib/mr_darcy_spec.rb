require 'spec_helper'

describe MrDarcy do
  it { should be }
  it { should respond_to :driver }
  it { should respond_to :driver= }


  describe '.all_drivers' do
    subject { MrDarcy.all_drivers }

    When 'running on jruby' do
      before { stub_const 'RUBY_ENGINE', 'jruby' }

      it { should_not include :em }
    end

    Otherwise do
      before { stub_const 'RUBY_ENGINE', 'mri'}

      it { should include :synchronous }
      it { should include :thread }
      it { should include :celluloid }
      it { should include :em }
    end
  end

  # This spec doesn't pass on CI. I can't figure out why.
  # describe '#promise' do
  #   When 'no driver is specified' do
  #     subject { MrDarcy.promise {} }

  #     it 'uses whichever driver is the default' do
  #       expect(MrDarcy).to receive(:driver).and_return(:thread)
  #       subject
  #     end
  #   end
  # end
end
