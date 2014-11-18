# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ara2yml/version'

Gem::Specification.new do |spec|
  spec.name          = 'ara2yml'
  spec.version       = Ara2yml::VERSION
  spec.authors       = ['AlexanderPavlenko']
  spec.email         = ['alerticus@gmail.com']
  spec.summary       = %q{Convert ARA to YAML}
  spec.description   = %q{Convert proprietary file format of Across v6 for exporting and (re-)importing projects into the YAML.}
  spec.homepage      = 'https://github.com/AlexanderPavlenko/ara2yml'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'rubyzip'
  spec.add_dependency 'mdb'
end
