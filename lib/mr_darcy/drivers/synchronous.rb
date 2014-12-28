#
# Driver used for testing synchronously.

module MrDarcy
  module Drivers
    module Synchronous
      module_function

      # Immediately yields whatever block is passed into it.
      def dispatch
        yield
      end

      # Immediately yields whatever block is passed into it.
      def wait
        yield
      end
    end
  end
end
