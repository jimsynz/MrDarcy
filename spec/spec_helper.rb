Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

require 'mr_darcy'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
  config.extend ContextHelpers
  config.extend OnAllDrivers
end
