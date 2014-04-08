shared_examples_for :thenable do
  it { should respond_to :then }
  it { should respond_to :fail }
  it { should respond_to :result }
  it { should respond_to :final }
  it { should respond_to :raise }
  it { should respond_to :unresolved? }
  it { should respond_to :resolved? }
  it { should respond_to :rejected? }
end
