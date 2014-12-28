require "mr_darcy/version"
require "mr_darcy/role"
require "mr_darcy/context"
require "mr_darcy/deferred"
require "mr_darcy/promise"

module MrDarcy

  module_function

  # Set the driver to use for asynchronicity.
  # See #all_drivers for a list of available
  # drivers on your platform.
  def driver=(driver)
    @driver=driver
  end

  # The current driver in use for asynchronicity.
  # Defaults to :Thread
  def driver
    @driver ||= :Thread
  end

  # The available drivers for your combination of Ruby implementation
  # and operating system.
  # Note that this is possible drivers, not that you have the necessary
  # dependencies installed - ie it doesn't check that you have required
  # celluloid before it tries to use it.
  def all_drivers
    return @drivers if @drivers && !@drivers.empty?
    drivers ||= %w| synchronous thread celluloid em |.map(&:to_sym)
    drivers.delete :em if RUBY_ENGINE=='jruby'
    @drivers = drivers
  end

  # Generate a new promise with the provided block.
  # Accepts the following options:
  #
  # * driver: override the default driver.
  #
  # :yields: promise
  #
  # Yields a promise into the block as the first
  # argument so that you can resolve or reject from
  # within the block.
  #
  #    MrDarcy.promise do |p|
  #      r = rand(10)
  #      if r > 5
  #        p.resolve r
  #      else
  #        p.reject  r
  #      end
  #    end
  def promise opts={}, &block
    driver = opts[:driver] || self.driver
    MrDarcy::Promise.new driver: driver, &block
  end

  # Generate a new promise representing a collection
  # of promises.
  # The collection promise resolves once all the
  # collected promises are resolved and rejects
  # as soon as the first promise rejects.
  #
  # This method collects all promises returned
  # from a provided block:
  #
  #   MrDarcy.all_promises do
  #     10.times.map do |i|
  #       MrDarcy.promise do |p|
  #         sleep 1
  #         p.resolve i
  #       end
  #     end
  #   end
  def all_promises opts={}
    MrDarcy::Promise::Collection.new yield, opts
  end

end
