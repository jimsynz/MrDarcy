module MrDarcy
  module Promise
    class State
      include Stateflow

      attr_accessor :promise

      stateflow do
        initial :unresolved

        state :unresolved

        state :resolved do
          after_enter :resolve_child_promise
        end

        state :rejected do
          after_enter :reject_child_promise
        end

        event :resolve do
          transitions from: :unresolved, to: :resolved
        end

        event :reject do
          transitions from: :unresolved, to: :rejected
        end
      end

      def initialize(promise)
        self.promise = promise
      end

      def resolve_child_promise
        promise.send :resolve_child_promise
      end

      def reject_child_promise
        promise.send :reject_child_promise
      end
    end
  end
end
