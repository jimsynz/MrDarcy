require 'spec_helper'

describe MrDarcy::Promise::ChildPromise do
  let(:child_promise) { MrDarcy::Promise::ChildPromise.new driver: :Synchronous }
  subject { child_promise }

  it { should respond_to :resolve_block }
  it { should respond_to :reject_block }

  describe '#parent_resolved' do
    let(:resolve_value) { :good }
    subject { child_promise.parent_resolved resolve_value }

    When 'it handles success' do
      let(:resolve_block) { proc {} }
      before { child_promise.resolve_block = resolve_block }

      it 'calls the resolve block' do
        expect(resolve_block).to receive(:call).with(resolve_value)
        subject
      end

      When 'the resolve block returns a value' do
        let(:resolve_block) { proc { :new_value } }

        it 'resolves' do
          expect { subject }.to change { child_promise.promise.resolved? }.from(false).to(true)
        end

        it 'sets the new value' do
          expect { subject }.to change { child_promise.promise.result }.to(:new_value)
        end
      end

      When 'the resolve block returns a new promise' do
        let(:promise) { MrDarcy::Promise::Synchronous.new proc {} }
        let(:resolve_block) { proc { promise } }

        it 'doesn\'t resolve' do
          expect { subject }.not_to change { child_promise.promise.resolved? }
        end

        it 'doesn\'t set the value' do
          expect { subject }.not_to change { child_promise.promise.result }
        end

        When 'the promise eventually resolves' do
          before  { child_promise.parent_resolved resolve_value }
          subject { promise.resolve :mr_good_stuff }

          it 'resolves' do
            expect { subject }.to change{ child_promise.promise.resolved? }.from(false).to(true)
          end

          it 'has the new value' do
            expect { subject }.to change { child_promise.promise.result }.to(:mr_good_stuff)
          end
        end

        When 'the promise eventually rejects' do
          before { child_promise.parent_resolved resolve_value }
          subject { promise.reject :mr_bad_stuff }

          it 'rejects' do
            expect { subject }.to change{ child_promise.promise.rejected? }.from(false).to(true)
          end

          it 'has the new value' do
            expect { subject }.to change { child_promise.promise.result }.to(:mr_bad_stuff)
          end
        end
      end
    end

    Otherwise do
      it 'is resolved' do
        subject
        expect(child_promise.promise).to be_resolved
      end

      it 'is resolved with the supplied value' do
        subject
        expect(child_promise.promise.result).to eq(resolve_value)
      end
    end
  end

  describe '#parent_rejected' do
    let(:reject_value) { :bad }
    subject { child_promise.parent_rejected reject_value }

    When 'it handles success' do
      let(:reject_block) { proc {} }
      before { child_promise.reject_block = reject_block }

      it 'calls the reject block' do
        expect(reject_block).to receive(:call).with(reject_value)
        subject
      end

      When 'the reject block returns a value' do
        let(:reject_block) { proc { :new_value } }

        it 'resolves' do
          expect { subject }.to change { child_promise.promise.resolved? }.from(false).to(true)
        end

        it 'sets the new value' do
          expect { subject }.to change { child_promise.promise.result }.to(:new_value)
        end
      end

      When 'the reject block returns a new promise' do
        let(:promise) { MrDarcy::Promise::Synchronous.new proc {} }
        let(:reject_block) { proc { promise } }

        it 'doesn\'t reject' do
          expect { subject }.not_to change { child_promise.promise.rejected? }
        end

        it 'doesn\'t set the value' do
          expect { subject }.not_to change { child_promise.promise.result }
        end

        When 'the promise eventually resolves' do
          before { child_promise.parent_rejected reject_value }
          subject { promise.resolve :mr_good_stuff }

          it 'resolves' do
            expect { subject }.to change{ child_promise.promise.resolved? }.from(false).to(true)
          end

          it 'has the new value' do
            expect { subject }.to change { child_promise.promise.result }.to(:mr_good_stuff)
          end
        end

        When 'the promise eventually rejects' do
          before { child_promise.parent_rejected reject_value }
          subject { promise.reject :mr_bad_stuff }

          it 'rejects' do
            expect { subject }.to change{ child_promise.promise.rejected? }.from(false).to(true)
          end

          it 'has the new value' do
            expect { subject }.to change { child_promise.promise.result }.to(:mr_bad_stuff)
          end
        end
      end
    end

    Otherwise do
      it 'is rejected' do
        subject
        expect(child_promise.promise).to be_rejected
      end

      it 'is rejected with the supplied value' do
        subject
        expect(child_promise.promise.result).to eq(reject_value)
      end
    end
  end
end
