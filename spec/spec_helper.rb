Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

require 'mr_darcy'
require 'pry'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
  config.extend ContextHelpers
end
