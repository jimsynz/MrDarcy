require 'spec_helper'

describe MrDarcy::Promise::Base do
  let(:promise_block) { proc {} }
  let(:mock_promise) do
    Class.new(MrDarcy::Promise::Base) do
      def schedule_promise
        yield
      end

      def generate_child_promise
        MrDarcy::Promise::ChildPromise.new driver: :synchronous
      end
    end.new(promise_block)
  end
  subject { mock_promise }

  it_behaves_like :thenable

  describe '#then' do
    let(:then_block) { proc {} }
    subject { mock_promise.then &then_block }

    it_behaves_like :thenable

    When 'the promise is already resolved' do
      before { mock_promise.resolve :good }
      it_behaves_like 'a resolved promise'

      it 'calls the then block with the result' do
        expect { |b| mock_promise.then(&b) }.to yield_with_args(:good)
      end

      it 'calls the then block only once' do
        expect { |b| mock_promise.then(&b) }.to yield_control.once
      end
    end

    When 'the promise is already rejected' do
      before { mock_promise.reject :bad }
      it_behaves_like 'a rejected promise'

      it 'does not call the then block' do
        expect { |b| mock_promise.then(&b) }.not_to yield_control
      end
    end

    Otherwise do
      it_behaves_like 'an unresolved promise'

      it 'does not call the then block' do
        expect { |b| mock_promise.then(&b) }.not_to yield_control
      end
    end
  end

  describe '#fail' do
    let(:fail_block) { proc {} }
    subject { mock_promise.fail &fail_block }

    it_behaves_like :thenable

    When 'the promise is already resolved' do
      before { mock_promise.resolve :good }
      it_behaves_like 'a resolved promise'

      it 'does not call the fail block' do
        expect { |b| mock_promise.fail(&b) }.not_to yield_control
      end
    end

    When 'the promise is already rejected' do
      before { mock_promise.reject :bad }

      When 'the fail block re-fails' do
        let(:fail_block) { proc { raise :bad } }

        it_behaves_like 'a rejected promise'
      end

      Otherwise do
        it_behaves_like 'a resolved promise'
      end

      it 'calls the fail block with the result' do
        expect { |b| mock_promise.fail(&b) }.to yield_with_args(:bad)
      end

      it 'calls the fail block only once' do
        expect { |b| mock_promise.fail(&b) }.to yield_control.once
      end
    end

    Otherwise do
      it_behaves_like 'an unresolved promise'

      it 'does not call the fail block' do
        expect { |b| mock_promise.fail(&b) }.not_to yield_control
      end
    end
  end

  describe '#result' do
    subject { -> { mock_promise.result } }
    it { should raise_error }
  end

  describe '#final' do
    subject { -> { mock_promise.final } }
    it { should raise_error }
  end

  describe '#raise' do
    before { mock_promise.stub result: :foo }
    subject { -> { mock_promise.raise } }

    When 'the promise is resolved' do
      before { mock_promise.resolve :good }

      it { should_not raise_error }
    end

    When 'the promise is rejected' do
      before { mock_promise.reject :bad }

      it { should raise_error }
    end

    When 'the promise is unresolved' do
      it { should_not raise_error }
    end
  end

  describe '#resolve' do
    let(:resolve_value) { :good }
    subject { mock_promise.resolve resolve_value }

    When 'the promise is already resolved' do
      before { mock_promise.resolve :previous }

      specify { expect { subject }.to raise_error }
    end

    When 'the promise is already rejected' do
      before { mock_promise.reject :previous }

      specify { expect { subject }.to raise_error }
    end

    Otherwise do
      specify { expect { subject }.to change{ mock_promise.resolved? }.from(false).to(true) }
      specify { expect { subject }.to change{ mock_promise.unresolved? }.from(true).to(false) }

      When 'there is a child promise' do
        let(:then_block) { proc {} }
        before { mock_promise.then(&then_block) }

        it 'calls the then block' do
          expect(then_block).to receive(:call).with(:good).once
          subject
        end
      end
    end
  end

  describe '#reject' do
    let(:reject_value) { :bad }
    subject { mock_promise.reject reject_value }

    When 'the promise is already resolved' do
      before { mock_promise.resolve :previous }

      specify { expect { subject }.to raise_error }
    end

    When 'the promise is already rejected' do
      before { mock_promise.reject :previous }

      specify { expect { subject }.to raise_error }
    end

    Otherwise do
      specify { expect { subject }.to change{ mock_promise.rejected? }.from(false).to(true) }
      specify { expect { subject }.to change{ mock_promise.unresolved? }.from(true).to(false) }

      When 'there is a child promise' do
        let(:fail_block) { proc {} }
        before { mock_promise.fail(&fail_block) }

        it 'calls the fail block' do
          expect(fail_block).to receive(:call).with(:bad).once
          subject
        end
      end
    end
  end
end
