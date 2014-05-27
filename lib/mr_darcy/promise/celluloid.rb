require 'celluloid/autostart'

module MrDarcy
  module Promise
    class Celluloid < Base
      class Actor
        include ::Celluloid

        def initialize
          @complete = false
        end

        def schedule block
          ::Celluloid::Future.new &block
        end

        def set_status status, value
          case status
          when :success
            @success.call value
          when :failure
            @failure.call value
          end
          signal :complete
          @complete = true
        end

        def on_success block
          @success = block
        end

        def on_failure block
          @failure = block
        end

        def await_completion
          return if @complete
          wait :complete
        end
      end

      def initialize *args
        @complete = false
        ensure_actor
        actor.on_success proc { |v| do_resolve v }
        actor.on_failure proc { |v| do_reject v }
        super
      end

      def resolve value
        actor.async.set_status :success, value
        self
      end

      def reject value
        actor.async.set_status :failure, value
        self
      end

      def result
        wait_until_complete
        get_value
      end

      def final
        wait_until_complete
        self
      end

      private

      def wait_until_complete
        return if @complete
        actor.alive? && actor.await_completion
        @complete = true
      end

      def will_resolve value
        @complete = true
      end

      def will_reject value
        @complete = true
      end

      def did_reject value
        actor.async.terminate
      end

      def did_resolve value
        actor.async.terminate
      end

      def generate_child_promise
        ChildPromise.new driver: :celluloid
      end

      def ensure_actor
        @actor ||= Actor.new
      end

      def actor
        @actor
      end

      def schedule_promise &block
        actor.async.schedule block
      end

    end
  end
end
