# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mr_darcy/version'

Gem::Specification.new do |spec|
  spec.name          = "mr_darcy"
  spec.version       = MrDarcy::VERSION
  spec.authors       = ["James Harton"]
  spec.email         = ["james@resistor.io"]
  spec.summary       = %q{A mashup of async Promises and DCI in Ruby.}
  spec.description   = <<-EOF
  MrDarcy takes async promises from the javascript word, DCI from Jim
  Gay's brain and sprinkles some ruby on top for great justice!
  EOF
  spec.homepage      = "https://github.com/jamesotron/MrDarcy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  %w| rake rspec guard guard-rspec guard-bundler terminal-notifier-guard
      pry eventmachine em-http-request celluloid |.each do |gem|
    spec.add_development_dependency gem
  end
end
