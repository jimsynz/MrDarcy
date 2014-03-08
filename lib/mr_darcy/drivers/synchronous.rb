module MrDarcy
  module Drivers
    module Synchronous
      module_function

      def dispatch
        yield
      end

      def wait
        yield
      end
    end
  end
end
