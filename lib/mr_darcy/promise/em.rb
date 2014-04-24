require 'eventmachine'

module MrDarcy
  module Promise
    class EM < Base
      class DeferrableAdapter
        include EventMachine::Deferrable
      end

      def initialize *args
        Kernel::raise "EventMachine driver is unsupported on JRuby, sorry" if RUBY_ENGINE=='jruby'
        unless EventMachine.reactor_running?
          ::Thread.new { EventMachine.run }
          ::Thread.pass until EventMachine.reactor_running?
        end
        @wait_lock = Mutex.new
        @wait_cond = ConditionVariable.new
        @wait_lock.lock
        deferrable_adapter.callback &method(:do_resolve)
        deferrable_adapter.errback &method(:do_reject)
        super
      end

      def resolve value
        deferrable_adapter.set_deferred_status :succeeded, value
        self
      end

      def reject value
        deferrable_adapter.set_deferred_status :failed, value
        self
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

      def wait_if_unresolved
        @wait_cond.wait @wait_lock if unresolved?
      end

      def deferrable_adapter
        @deferrable_adapter ||= DeferrableAdapter.new
      end

      def schedule_promise &block
        EventMachine.defer block
      end

      def resolve_or_reject_child_as_needed
        EventMachine.defer { super }
      end

      def generate_child_promise
        ChildPromise.new driver: :em
      end

      def notify_waiting
        EventMachine.defer { @wait_cond.signal }
      end

    end
  end
end
