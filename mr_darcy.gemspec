# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mr_darcy/version'

Gem::Specification.new do |spec|
  spec.name          = "mr_darcy"
  spec.version       = MrDarcy::VERSION
  spec.authors       = ["James Harton"]
  spec.email         = ["james@resistor.io"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
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
