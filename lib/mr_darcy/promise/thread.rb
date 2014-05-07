require 'thread'
require 'fiber'

module MrDarcy
  module Promise
    class Thread < Base

      def initialize *args
        @semaphore = Mutex.new
        semaphore.synchronize { @complete = false }
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
        ::Thread.new &block
      end

      def resolve_child_promise
        ::Thread.new { super }
      end

      def reject_child_promise
        ::Thread.new { super }
      end

      def did_resolve value
        complete!
      end

      def did_reject value
        complete!
      end

      def wait_if_unresolved
        return if complete?
        semaphore.synchronize do
          @wait = ConditionVariable.new
          @wait.wait(semaphore)
        end
      end

      def generate_child_promise
        ChildPromise.new driver: :thread
      end

      def complete?
        # semaphore.synchronize { @complete }
        @complete
      end

      def complete!
        semaphore.synchronize do
          @complete = true
          @wait.broadcast if @wait
        end
      end

      def semaphore
        @semaphore
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
