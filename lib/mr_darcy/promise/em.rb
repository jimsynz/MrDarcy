require 'eventmachine'

module MrDarcy
  module Promise
    class EM < Base
      class DeferrableAdapter
        include EventMachine::Deferrable
      end

      def initialize *args
        raise "EventMachine driver is unsupported on JRuby, sorry" if RUBY_ENGINE=='jruby'
        unless EventMachine.reactor_running?
          ::Thread.new { EventMachine.run }
          ::Thread.pass until EventMachine.reactor_running?
        end
        deferrable_adapter.callback do |value|
          set_value_to value
          state_machine_resolve
          resolve_child_promise
          notify_waiting
        end
        deferrable_adapter.errback do |value|
          set_value_to value
          state_machine_reject
          reject_child_promise
          notify_waiting
        end
        channel
        super
      end

      def resolve value
        deferrable_adapter.set_deferred_status :succeeded, value
      end

      def reject value
        deferrable_adapter.set_deferred_status :failed, value
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

      def notify_waiting
        until wait_queue.num_waiting == 0
          wait_queue.push nil
        end
      end

      def wait_if_unresolved
        wait_queue.pop if unresolved?
      end

      def wait_queue
        @wait_queue ||= Queue.new
      end

      def deferrable_adapter
        @deferrable_adapter ||= DeferrableAdapter.new
      end

      def schedule_promise &block
        EventMachine.defer block
      end

      def channel
        @channel ||= EventMachine::Channel.new
      end

      def generate_child_promise
        ChildPromise.new driver: :em
      end

    end
  end
end
