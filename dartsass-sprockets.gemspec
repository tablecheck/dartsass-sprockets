# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sassc/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "dartsass-sprockets"
  spec.version       = SassC::Rails::VERSION
  spec.authors       = ["Ryan Boland", "Johnny Shields"]
  spec.email         = ["ryan@tanookilabs.com"]
  spec.summary       = 'Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.'
  spec.description   = 'Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.'
  spec.homepage      = "https://github.com/tablecheck/dartsass-sprockets"
  spec.license       = "MIT"

  spec.files = Dir['lib/**/*.rb'] + %w[LICENSE.txt README.md]
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.required_ruby_version = '>= 2.6.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency "dartsass-ruby", "~> 3.0"
  spec.add_dependency "tilt"
  spec.add_dependency 'railties', '>= 4.0.0'
  spec.add_dependency 'sprockets', '> 3.0'
  spec.add_dependency 'sprockets-rails'
end
