shared_examples_for "a promise" do
  it_behaves_like :thenable

  describe '#then' do
    its(:then) { should be_a MrDarcy::Promise::Base }
  end

  describe '#fail' do
    its(:fail) { should be_a MrDarcy::Promise::Base }
  end
end

shared_examples_for 'a resolved promise' do
  it_should_behave_like 'a promise'

  its(:final)  { should be_resolved }
  its(:final)  { should_not be_rejected }
  its(:final)  { should_not be_unresolved }

  it "doesn't raise an exception" do
    expect { subject.raise }.not_to raise_exception
  end
end

shared_examples_for 'an unresolved promise' do
  it_should_behave_like 'a promise'

  its(:final)  { should_not be_resolved }
  its(:final)  { should_not be_rejected }
  its(:final)  { should be_unresolved }

  it "doesn't raise an exception" do
    expect { subject.raise }.not_to raise_exception
  end
end

shared_examples_for 'a rejected promise' do
  it_should_behave_like 'a promise'

  its(:final)  { should_not be_resolved }
  its(:final)  { should be_rejected }
  its(:final)  { should_not be_unresolved }

  it "raises an exception" do
    expect { subject.raise }.to raise_exception
  end
end
