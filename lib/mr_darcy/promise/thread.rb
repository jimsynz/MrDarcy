module MrDarcy
  module Promise
    class Thread < Base

      def initialize *args
        @wait_lock = Mutex.new
        @wait_cond = ConditionVariable.new
        @wait_lock.lock
        semaphore
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

      private

      def schedule_promise &block
        ::Thread.new(&block)
      end

      def notify_waiting
        @wait_cond.signal
      end

      def resolve_or_reject_child_as_needed
        ::Thread.new do
          super
        end
      end

      def wait_if_unresolved
        @wait_cond.wait @wait_lock if unresolved?
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def set_value_to value
        semaphore.synchronize { super }
      end

      def state_machine
        semaphore.synchronize { super }
      end

      def child_promise
        semaphore.synchronize { super }
      end

      def value
        semaphore.synchronize { super }
      end

    end
  end
end
