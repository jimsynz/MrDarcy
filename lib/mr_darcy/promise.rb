# :nodoc:
module MrDarcy
  module Promise
    autoload :State,        File.expand_path('../promise/state', __FILE__)
    autoload :Base,         File.expand_path('../promise/base', __FILE__)
    autoload :DSL,          File.expand_path('../promise/dsl', __FILE__)
    autoload :ChildPromise, File.expand_path('../promise/child_promise', __FILE__)

    autoload :Synchronous,  File.expand_path('../promise/synchronous', __FILE__)
    autoload :Thread,       File.expand_path('../promise/thread', __FILE__)
    autoload :Celluloid,    File.expand_path('../promise/celluloid', __FILE__)
    autoload :EM,           File.expand_path('../promise/em', __FILE__)
    autoload :Collection,   File.expand_path('../promise/collection', __FILE__)

    module_function

    def new opts={}, &block
      driver = opts[:driver] || ::MrDarcy.driver
      case driver
      when :thread, :Thread
        ::MrDarcy::Promise::Thread.new block
      when :synchronous, :Synchronous
        ::MrDarcy::Promise::Synchronous.new block
      when :celluloid, :Celluloid
        ::MrDarcy::Promise::Celluloid.new block
      when :em, :EM, :event_machine, :eventmachine, :EventMachine
        ::MrDarcy::Promise::EM.new block
      else
        raise "Unknown driver #{driver}"
      end
    end

  end
end
