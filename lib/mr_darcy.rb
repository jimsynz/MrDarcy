require "mr_darcy/version"
require "mr_darcy/role"
require "mr_darcy/context"
require "mr_darcy/deferred"
require "mr_darcy/promise"

module MrDarcy

  module_function

  def driver=(driver)
    @driver=driver
  end

  def driver
    @driver ||= :Thread
  end

  def all_drivers
    %i| synchronous thread celluloid em |
  end

  def promise driver: driver, &block
    MrDarcy::Promise.new driver: driver, &block
  end
end
