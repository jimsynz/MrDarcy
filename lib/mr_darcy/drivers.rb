# :nodoc:
module MrDarcy
  module Drivers
    autoload :Synchronous, File.expand_path('../drivers/synchronous.rb', __FILE__)
    autoload :Thread,      File.expand_path('../drivers/thread.rb', __FILE__)
    autoload :Celluloid,   File.expand_path('../drivers/celluloid.rb', __FILE__)

    module_function

    def all
      [ Synchronous, Thread, Celluloid ]
    end
  end
end
