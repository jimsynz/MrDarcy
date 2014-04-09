require 'eventmachine'

module MrDarcy
  module Promise
    class EM < Thread

      def initialize *args
        raise "EventMachine driver is unsupported on JRuby, sorry" if RUBY_ENGINE=='jruby'
        unless EventMachine.reactor_running?
          ::Thread.new { EventMachine.run }
          ::Thread.pass until EventMachine.reactor_running?
        end
        super
      end

      private

      def schedule_promise &block
        EventMachine.schedule block
      end

      def generate_child_promise
        ChildPromise.new driver: :em
      end

    end
  end
end
