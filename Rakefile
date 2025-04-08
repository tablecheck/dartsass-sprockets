# frozen_string_literal: true

require 'bundler/gem_tasks'

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/*_test.rb').each { |f| require(f) }
end
task default: [:test]

namespace :tests do
  gemfiles = Dir['gemfiles/*.gemfile'].map { |f| File.basename(f, '.gemfile') }.freeze

  gemfiles.each do |gemfile|
    desc "Run tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake test"
    end
  end

  desc 'Run tests against all common asset pipeline setups'
  task :all do
    gemfiles.each do |gemfile|
      Rake::Task["tests:#{gemfile}"].invoke
    end
  end
end
