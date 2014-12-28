require 'thread'

module MrDarcy
  module Promise
    class Collection
      include Enumerable
      extend Forwardable

      def_delegators :my_promise, :rejected?, :resolved?, :unresolved?, :raise, :result, :then, :fail

      # Creates a meta-promise based on a collection of promises.
      # * promises: an array of promises
      # * opts: options for MrDarcy.promise
      def initialize promises, opts={}
        @lock     = Mutex.new
        @promises = []
        @size     = promises.size
        @promise  = MrDarcy.promise opts do
          promises.each do |p|
            add_promise p
          end
        end
      end

      # See MrDarcy::Promise::Base#final
      def final
        my_promise.final
        self
      end

      # Allow iteration of promises for Enumerable.
      def each &block
        promises.each &block
      end

      # Add a new promise to our collection.
      def push promise
        @lock.synchronize { @size = @size + 1 }
        add_promise promise
      end
      alias << push

      # Return the number of promises in this collection.
      def size
        @lock.synchronize { @size }
      end

      # Return an array of promises in this collection.
      def promises
        @lock.synchronize { @promises }
      end

      private

      def add_promise promise
        ::Kernel.raise RuntimeError, "Collection already resolved" if my_promise && resolved?
        ::Kernel.raise RuntimeError, "Collection already rejected" if my_promise && rejected?
        ::Kernel.raise ArgumentError, "must be thenable" unless promise.respond_to?(:then) && promise.respond_to?(:fail)
        @lock.synchronize { @promises.push promise }
        set_up_promise promise
      end

      def my_promise
        @lock.synchronize { @promise }
      end

      def set_up_promise promise
        promise.then(&method(:record_resolve))
        promise.fail(&method(:record_reject))
        # promise.then { |v| record_resolve v }.fail { |v| record_reject v }
      end

      def record_resolve value
        @lock.synchronize do
          resolve_promise if can_resolve?
          value
        end
      end

      # NOT THREADSAFE:
      #   because they're called from within #record_resolve
      #   which locks.
      def resolve_promise
        @promise.resolve @promises.map(&:result)
      end

      def can_resolve?
        all_promises_present? && all_promises_resolved? && @promise.unresolved?
      end

      def all_promises_present?
        @promises.size == @size
      end

      def all_promises_resolved?
        @promises.all?(&:resolved?)
      end
      # /NOT THREADSAFE

      def record_reject value
        my_promise.reject value
        value
      end

    end
  end
end
