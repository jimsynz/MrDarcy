require 'spec_helper'

describe MrDarcy::Context do
  context 'class methods' do
    subject { described_class }
    it { should respond_to :role }
    it { should respond_to :action }

    describe '.role' do
      subject { described_class.role :test_name }

      it { should be_a MrDarcy::Role }
      its(:name) { should eq :test_name }
    end

    describe '.action' do
      subject { -> { described_class.action :action_name, &->{} } }

      it { should change { described_class.instance_methods.member? :action_name }.from(false).to(true) }
    end
  end


  it { should respond_to :promise }
end
