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
end
