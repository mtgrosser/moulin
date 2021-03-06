# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moulin/version'

Gem::Specification.new do |spec|
  spec.name          = "moulin"
  spec.version       = Moulin::VERSION
  spec.authors       = ["Matthias Grosser"]
  spec.email         = ["mtgrosser@gmx.net"]

  spec.summary       = %q{An alternative Ruby wrapper for the Paymill API (that does not rely on global configuration variables)}
  spec.description   = %q{An alternative Ruby wrapper for the Paymill API (that does not rely on global configuration variables)}
  spec.homepage      = "https://github.com/mtgrosser/moulin"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"
end
