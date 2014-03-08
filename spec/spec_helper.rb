Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

require 'mr_darcy'

RSpec.configure do |config|
  config.extend ContextHelpers
end
