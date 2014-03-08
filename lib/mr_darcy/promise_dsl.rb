module MrDarcy
  class PromiseDSL

    attr_accessor :promise

    def initialize(_promise)
      self.promise = _promise
    end

    def resolve(value)
      promise.value = value
      promise.resolve!
    end

    def reject(exception)
      promise.value = exception
      promise.reject!
    end

  end
end
