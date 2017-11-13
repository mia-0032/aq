# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aq/version'

Gem::Specification.new do |spec|
  spec.name          = "aq"
  spec.version       = Aq::VERSION
  spec.authors       = ["Yoshihiro MIYAI"]
  spec.email         = ["msparrow17@gmail.com"]

  spec.description   = 'Command Line Tool for AWS Athena (bq command like)'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/mia-0032/aq'
  spec.has_rdoc      = false
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.0"
  spec.add_dependency "aws-sdk-athena", "~> 1.0"
  spec.add_dependency "aws-sdk-s3", "~> 1.0"
  spec.add_dependency "kosi", "~> 1.0"
  spec.add_dependency "highline", "~> 1.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "test-unit-rr"
end
