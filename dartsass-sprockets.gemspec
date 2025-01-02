# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sassc/rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'dartsass-sprockets'
  spec.version     = SassC::Rails::VERSION
  spec.authors     = ['Ryan Boland', 'Johnny Shields']
  spec.email       = ['ryan@tanookilabs.com']
  spec.summary     = 'Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.'
  spec.description = 'Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.'
  spec.homepage    = 'https://github.com/tablecheck/dartsass-sprockets'
  spec.license     = 'MIT'

  spec.files = Dir['lib/**/*.rb'] + %w[LICENSE.txt README.md]
  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'railties', '>= 4.0.0'
  spec.add_dependency 'sassc-embedded', '~> 1.80.1'
  spec.add_dependency 'sprockets', '> 3.0'
  spec.add_dependency 'sprockets-rails'
  spec.add_dependency 'tilt'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
