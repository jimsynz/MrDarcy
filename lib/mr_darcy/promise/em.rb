require 'eventmachine'

module MrDarcy
  module Promise
    class EM < Base

      def initialize *args
        @wait_lock = Mutex.new
        @wait_cond = ConditionVariable.new
        @wait_lock.lock
        unless EventMachine.reactor_running?
          ::Thread.new { EventMachine.run }
          ::Thread.pass until EventMachine.reactor_running?
        end
        super
      end

      def result
        wait_if_unresolved
        value
      end

      def final
        wait_if_unresolved
        self
      end

      def resolve value
        super
        @wait_cond.signal
      end

      def reject value
        super
        @wait_cond.signal
      end

      private

      def schedule_promise
        EventMachine.defer proc do
          yield
        end
      end

      def wait_if_unresolved
        @wait_cond.wait @wait_lock if unresolved?
      end

      def generate_child_promise
        ChildPromise.new driver: :em
      end

    end
  end
end
