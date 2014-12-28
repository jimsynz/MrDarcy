# This class implements a synchronous interface to promise execution.
# It's not much use, except for unit testing.

module MrDarcy
  module Promise
    # An implementation of synchronous promises, only for testing because
    # it violates several rules of promises.
    class Synchronous < Base

      def result
        value
      end

      def final
        self
      end

      private

      def schedule_promise
        yield
      end

      def generate_child_promise
        ChildPromise.new driver: :synchronous
      end
    end
  end
end
