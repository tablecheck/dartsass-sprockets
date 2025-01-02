- **3.2.0**
  - Bump sassc-embedded dependency to 1.80.1.
  - Allow pass-thru of all sass-embedded options.
  - @ntkme - [Fix custom importer and avoid mutex lock for custom functions](https://github.com/tablecheck/dartsass-sprockets/pull/22)
  - @botandrose - [Restore import tracking from Sprockets::SassProcessor so that edits to secondary imports are tracked](https://github.com/tablecheck/dartsass-sprockets/pull/29)
  - @jukra - [Alter the config to pass a --quiet-deps flag](https://github.com/tablecheck/dartsass-sprockets/pull/27)
  - Remove config.sass.line_comments.
  - Add Ruby 3.4 to Github CI tests.

- **3.1.0**
  - Change dependency from dartsass-ruby to sassc-embedded.
  - Drop support for Ruby prior to 3.1.
  - Add Rubocop and fix all issues.

- **3.0.0**
  - [Release as dartsass-sprockets gem](https://github.com/tablecheck/dartsass-sprockets/pull/1)

- **2.1.2**
  - [Correct reference to SassC::Script::Value::String](https://github.com/sass/sassc-rails/pull/129)

- **2.1.1**
  - [Fix Scaffolding](https://github.com/sass/sassc-rails/pull/119)

- **2.1.0**
  - [JRuby support](https://github.com/sass/sassc-rails/pull/113)
  - [SCSS / SASS scaffolding](https://github.com/sass/sassc-rails/pull/112)

- **2.0.0**
  - [Drop support for Sprockets 2](https://github.com/sass/sassc-rails/pull/109)
  - [Remove dependency on Ruby Sass](https://github.com/sass/sassc-rails/pull/109)

- **1.3.0**
  - [Silence Sprockets deprecation warnings](https://github.com/sass/sassc-rails/pull/76)
  - [Sprockets 4 compatibility](https://github.com/sass/sassc-rails/pull/65)

- **1.2.1**
  - Bump SassC (and thus LibSass) version

- **1.2.0**
  - [Support sprockets-rails 3](https://github.com/sass/sassc-rails/pull/41)
  - [Only depend on Railties instead of full Rails](https://github.com/sass/sassc-rails/pull/52)

- **1.1.0**
  - Moved under the official sass organization!
  - [Source line comments](https://github.com/sass/sassc-rails/pull/24) (`app.config.sass.line_comments`)
  - [Prevent sass-rails railtie from running](https://github.com/sass/sassc-rails/pull/34)
  - [CSS compression may be disabled in test mode](https://github.com/sass/sassc-rails/issues/33). Special thanks to [this Sass-Rails PR](https://github.com/rails/sass-rails/pull/338) for inspiration.
 
- **1.0.0**
  - Initial Release
  - Add support for inline source maps
  - Support compression in the way that Sass-Rails handles it
