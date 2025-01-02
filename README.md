# Dart Sass for Spockets

[![build](https://github.com/tablecheck/dartsass-sprockets/actions/workflows/build.yml/badge.svg)](https://github.com/tablecheck/dartsass-sprockets/actions/workflows/build.yml)
[![gem](https://badge.fury.io/rb/dartsass-sprockets.svg)](https://rubygems.org/gems/dartsass-sprockets)

Use [Dart Sass](https://sass-lang.com/dart-sass) with Sprockets and the Ruby on Rails asset pipeline.

This gem is a fork of [sass/sassc-rails](https://github.com/sass/sassc-rails)
which maintains API compatibility but delegates to the
[sass-embedded](https://github.com/sass-contrib/sass-embedded-host-ruby) gem
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

### Version Support

The current version of `dartsass-sprockets` supports:
- Ruby 3.1+
- Rails 6.1+

For older versions of Ruby and Rails may be supported with earlier versions of this gem.

## Configuration

The following options are exposed via `Rails.application.config.sass.{option}`.
Options denoted with * are handed by the sass-embedded gem and passed into Dart Sass;
refer to [the sass-embedded documentation](https://rubydoc.info/gems/sass-embedded/Sass)
and the [Dart Sass documentation](https://sass-lang.com/documentation/js-api/interfaces/options/).

| Option                  | Type          | Description                                                                                                                   |
|-------------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------|
| `load_paths`            | Array<String> | Additional paths to look for imported files.                                                                                  |
| `inline_source_maps`    | Boolean       | If `true`, will append source maps inline to the generated CSS file. Refer to section below.                                  |
| `style`*                | Symbol        | `:expanded` (default) or `:compressed`. Recommended to use `:compressed` in Production.                                       |
| `charset`*              | Boolean       | Whether to include a @charset declaration or byte-order mark in the CSS output (default `true`).                              |
| `logger`*               | Object        | An object to use to handle warnings and/or debug messages from Sass.                                                          |
| `alert_ascii`*          | Boolean       | If `true`, Dart Sass will exclusively use ASCII characters in its error and warning messages (default `false`).               |
| `alert_color`*          | Boolean       | If `true`, Dart Sass will use ANSI color escape codes in its error and warning messages (default `false`).                    |
| `verbose`*              | Boolean       | By default (`false`) Dart Sass logs up to five occurrences of each deprecation warning. Setting to `true` removes this limit. |
| `quiet_deps`*           | Boolean       | If `true`, Dart Sass won’t print warnings that are caused by dependencies (default `false`).                                  |
| `silence_deprecations`* | Array<String> | An array of active deprecations to ignore. Refer to (deprecations)[dartsass-deprecations].                                    |
| `fatal_deprecations`*   | Array<String> | An array of deprecations to treat as fatal. Refer to (deprecations)[dartsass-deprecations].                                   |
| `future_deprecations`*  | Array<String> | An array of future deprecations to opt-into early. Refer to (deprecations)[dartsass-deprecations].                            |
| `importers`*            | Array<Object> | Custom importers to use when resolving `@import` directives.                                                                  |

When changing config options in Development environment,
you may need to clear your assets cache (`rm -r tmp/cache/assets`)
and restart your Rails server.

## Production Configuration

Recommended to set in your `production.rb` file:

```ruby
# config/environments/production.rb
config.sass.style = :compressed
```

## Development Configuration

To turn on inline source maps, add the following configuration
to your `development.rb` file:

```ruby
# config/environments/development.rb
config.sass.inline_source_maps = true
```

Note these source maps appended *inline* to the compiled `application.css` file.
(They will *not* generate additional files.)

### Upgrading from Legacy Sass Rails

This gem is a drop-in replacement to [sass-rails](https://github.com/rails/sass-rails).
Note the following differences:

* This library does not apply SASS processing to `.css` files. Please ensure all your SASS files have file extension `.scss`.
* `config.sass.style` values `:nested` and `:compact` will behave as `:expanded`. Use `:compressed` for minification.
* `config.sass.line_comments` option is ignored and will always be disabled.

## Alternatives

* [dartsass-rails](https://github.com/rails/dartsass-rails): The Rails organization
  maintains its own wrapper for Dart Sass. Unlike this gem, dartsass-rails does
  not support Sprockets.

## Credits

* This gem is maintained and used in production by [TableCheck](https://www.tablecheck.com/en/join). (We'd be very glad if the Sass organization could take over maintainership in the future!)
* Thank you to [Natsuki](https://ntk.me) for the [sass-embedded](https://github.com/sass-contrib/sass-embedded-host-ruby) gem.
* Credit to [Ryan Boland](https://ryanboland.com) and the authors of the original
  [sass/sassc-rails](https://github.com/sass/sassc-rails) and
  [sass-rails](https://github.com/rails/sass-rails) gems.
* See our [awesome contributors](https://github.com/tablecheck/dartsass-sprockets/graphs/contributors).

### Contributing

1. Fork it ([https://github.com/tablecheck/dartsass-sprockets/fork](https://github.com/tablecheck/dartsass-sprockets/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`) - try to include tests
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[dartsass-deprecations]: https://github.com/sass/sass/blob/40c50cb/js-api-doc/deprecations.d.ts#L260
