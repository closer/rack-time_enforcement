# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/time_enforcement/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-time_enforcement"
  spec.version       = Rack::TimeEnforcement::VERSION
  spec.authors       = ["closer"]
  spec.email         = ["closer009@gmail.com"]

  spec.summary       = %q{Time traveling each request for rack applications.}
  spec.homepage      = "https://github.com/closer/rack-time_enforcement"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "timecop", "~> 0.7.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
