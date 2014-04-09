module MrDarcy
  class Deferred

    attr_accessor :promise, :last_promise

    %w| resolved? rejected? unresolved? resolve reject final result |.map(&:to_sym).each do |method|
      define_method method do |*args|
        promise.public_send method, *args
      end
    end

    def then &block
      self.last_promise = last_promise.then(&block)
    end

    def fail &block
      self.last_promise = last_promise.fail(&block)
    end

    def initialize opts={}
      driver = opts[:driver] || MrDarcy.driver
      self.promise = MrDarcy::Promise.new(driver: driver) {}
      self.last_promise = promise
    end
  end
end
