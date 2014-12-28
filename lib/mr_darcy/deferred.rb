require 'forwardable'

module MrDarcy

  # A wrapper around promises that can be externally resolved.
  class Deferred
    extend Forwardable

    def_delegators :last_promise, :resolved?, :rejected?, :unresolved?, :resolve, :reject, :final, :result, :raise

    attr_reader :promise, :last_promise

    # See MrDarcy::Promise::Base#then
    def then &block
      self.last_promise = last_promise.then(&block)
    end

    # See MrDarcy::Promise::Base#fail
    def fail &block
      self.last_promise = last_promise.fail(&block)
    end

    # Create a new deferred.
    # Takes the following options:
    #
    # * driver: override the default driver for this promise.
    def initialize opts={}
      driver = opts[:driver] || MrDarcy.driver
      self.promise = MrDarcy::Promise.new(driver: driver) {}
      self.last_promise = promise
    end

    private

    attr_writer :promise, :last_promise
  end
end
