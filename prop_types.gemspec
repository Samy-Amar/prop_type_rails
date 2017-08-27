# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prop_types/version'

Gem::Specification.new do |spec|
  spec.name = 'prop_types'
  spec.version = PropTypes::VERSION
  spec.authors = ['Samy Amar']
  spec.email = ['samy.amar.paris@gmail.com']

  spec.summary = 'Allows use of PropTypes in Rails partials'
  spec.description = "
  Check variables exist and what class they're in.
  Prevents bad surprises when using big partials
  "
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
