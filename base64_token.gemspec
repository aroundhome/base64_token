# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'base64_token/version'

Gem::Specification.new do |spec|
  spec.name          = 'base64_token'
  spec.version       = Base64Token::VERSION
  spec.authors       = ['be Around GmbH']
  spec.email         = ['oss@aroundhome.de']
  spec.summary       = 'Encodes ruby hashes as encrypted and URL-safe tokens.'
  spec.homepage      = 'https://github.com/aroundhome/base64_token'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'rbnacl', '>= 6.0.0', '< 8.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'aroundhome_cops', '~> 4.0'
end
