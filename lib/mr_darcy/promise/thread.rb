module MrDarcy
  module Promise
    class Thread < Base

      def initialize *args
        @wait_lock = Mutex.new
        @wait_cond = ConditionVariable.new
        @wait_lock.lock
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

      def schedule_promise &block
        ::Thread.new &block
      end

      def wait_if_unresolved
        @wait_cond.wait @wait_lock if unresolved?
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

      def set_value_to value
        semaphore.synchronize { super }
      end

      def state_machine_resolve
        semaphore.synchronize { super }
      end

      def state_machine_reject
        semaphore.synchronize { super }
      end

    end
  end
end
