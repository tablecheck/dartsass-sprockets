# Dart Sass for Spockets

[![build](https://github.com/tablecheck/dartsass-sprockets/actions/workflows/build.yml/badge.svg)](https://github.com/tablecheck/dartsass-sprockets/actions/workflows/build.yml)
[![gem](https://badge.fury.io/rb/dartsass-sprockets.svg)](https://rubygems.org/gems/dartsass-sprockets)

Use [Dart Sass](https://sass-lang.com/dart-sass) with Sprockets and the Ruby on Rails asset pipeline.

This gem is a fork of [sass/sassc-rails](https://github.com/sass/sassc-rails)
which maintains API compatibility but delegates to the
[dartsass-ruby](https://github.com/tablecheck/dartsass-ruby) gem
which uses Dart Sass instead of the libsass C implmentation.

For ease of upgrading, the root namespace `::SassC` is still used by this gem,
although it is now a misnomer. This is planned to be renamed in a future
major version release.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dartsass-sprockets'
```

This will automatically configure your default Rails
`config.assets.css_compressor` to use `:sass`.

### Upgrading to Dart Sass

This gem is a drop-in replacement to [sass-rails](https://github.com/rails/sass-rails).
Note the following differences:

* `config.sass.style` values `:nested` and `:compact` will behave as `:expanded`. Use `:compressed` for minification.
* `config.sass.line_comments` option is ignored and will always be disabled.

## Inline Source Maps

To turn on inline source maps, add the following configuration
to your `development.rb` file:

```ruby
# config/environments/development.rb
config.sass.inline_source_maps = true
```

After adding this config line, you may need to clear your assets cache
(`rm -r tmp/cache/assets`), stop Spring, and restart your Rails server.

Note these source maps are *inline* and will be appended to the compiled
`application.css` file. (They will *not* generate additional files.)

## Alternatives

* [dartsass-rails](https://github.com/rails/dartsass-rails): The Rails organization
  maintains its own wrapper for Dart Sass. Unlike this gem, dartsass-rails does
  not support Sprockets.

## Credits

* This gem is maintained and used in production by [TableCheck](https://www.tablecheck.com/en/join). (We'd be very glad if the Sass organization could take over maintainership in the future!)
* Credit to [Ryan Boland](https://ryanboland.com) and the authors of the original
  [sass/sassc-rails](https://github.com/sass/sassc-rails) and
  [sass-rails](https://github.com/rails/sass-rails) gems.
* See our [awesome contributors](https://github.com/tablecheck/sassc-ruby/graphs/contributors).

### Contributing

1. Fork it ([https://github.com/tablecheck/dartsass-sprockets/fork](https://github.com/tablecheck/dartsass-sprockets/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`) - try to include tests
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
