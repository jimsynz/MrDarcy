require 'mr_darcy/role'

describe MrDarcy::Role do
  let(:name) { :money_source }
  let(:opts) { Hash.new }
  let(:role_methods) do
    proc do
      def really_a_money_source?
        :yup
      end
    end
  end
  let(:role) { MrDarcy::Role.new name, opts, &role_methods }
  subject { role }

  it { should respond_to :name }
  it { should respond_to :options }

  describe '#name' do
    subject { role.name }

    it { should eq name }
  end

  describe '#options' do
    let(:opts) { { test_options: true } }
    subject { role.options }

    it { should eq opts }
  end

  describe '#pollute' do
    let(:player) { Object.new }

    context 'pollution' do
      before  { role.pollute player }
      subject { player }

      it { should respond_to :really_a_money_source? }
      its(:really_a_money_source?) { should eq :yup }
    end

    context "when the role has a method requirement" do
      let(:opts) { { must_respond_to: :name } }
      subject { -> { role.pollute player } }

      context "and the player does not implement it" do
        it { should raise_error }
      end

      context "and the player does implement it" do
        let(:player) { Class.new { def name; 'my name'; end }.new }
        it { should_not raise_error }
      end
    end

    context "when the role is a method refusal" do
      let(:opts) { { must_not_respond_to: :name } }
      subject { -> { role.pollute player } }

      context "and the player does not implement it" do
        it { should_not raise_error }
      end

      context "and the player does implement it" do
        let(:player) { Class.new { def name; 'my name'; end }.new }
        it { should raise_error }
      end
    end

    context "when there is an unknown option" do
      let(:opts) { { must_be_super_awesome: true } }
      subject { -> { role.pollute player } }
      it { should raise_error }
    end
  end

  describe '#clean' do
    let(:player) { Object.new }
    before do
      role.pollute player
      expect(player).to respond_to :really_a_money_source?
      role.clean player
    end
    subject { player }

    it { should_not respond_to :really_a_money_source? }
  end unless RUBY_ENGINE == 'jruby'
end
