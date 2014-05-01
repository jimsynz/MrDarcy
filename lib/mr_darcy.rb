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
    return @drivers if @drivers && !@drivers.empty?
    drivers ||= %w| synchronous thread celluloid em |.map(&:to_sym)
    drivers.delete :em if RUBY_ENGINE=='jruby'
    @drivers = drivers
  end

  def promise opts={}, &block
    driver = opts[:driver] || self.driver
    MrDarcy::Promise.new driver: driver, &block
  end

end
