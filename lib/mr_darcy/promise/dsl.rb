module MrDarcy
  module Promise
    # Syntax wrapper around Promise. Can probably be removed now.
    class DSL
      extend Forwardable

      def_delegators :@promise, :resolve, :reject, :unresolved?, :resolved?, :rejected?, :then, :fail, :result, :final

      def initialize promise
        @promise = promise
      end

    end
  end
end
