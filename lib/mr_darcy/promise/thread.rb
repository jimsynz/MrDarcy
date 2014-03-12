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
        semaphore.synchronize do
          super
          @wait_cond.signal
        end
      end

      def reject value
        semaphore.synchronize do
          super
          @wait_cond.signal
        end
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

    end
  end
end
