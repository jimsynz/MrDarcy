require "mr_darcy/version"
require "mr_darcy/role"
require "mr_darcy/context"
require "mr_darcy/deferred"
require "mr_darcy/promise"
require "mr_darcy/promise_dsl"
require "mr_darcy/drivers/synchronous"
require "mr_darcy/drivers/thread"

module MrDarcy

  module_function

  def driver=(driver)
    @driver=driver
  end

  def driver
    @driver ||= MrDarcy::Drivers::Synchronous
  end
end
