# frozen_string_literal: true

require_relative 'test_helper'

class SassRailsTest < Minitest::Test
  attr_reader :app

  def setup
    @app = Class.new(Rails::Application).new
    @app.config.active_support.deprecation = :log
    @app.config.eager_load = false
    @app.config.root = File.join(File.dirname(__FILE__), 'dummy')
    @app.config.log_level = :debug

    # reset config back to default
    @app.config.assets.delete(:css_compressor)
    @app.config.sass = ActiveSupport::OrderedOptions.new
    @app.config.sass.preferred_syntax = :scss
    @app.config.sass.load_paths = []

    # TODO: Sass @import directive will be removed in the next version of
    # Dart Sass. Tests need to be switch to @use when that happens.
    @app.config.sass.silence_deprecations = %w[import]

    # Add a fake compressor for testing purposes
    Sprockets.register_compressor 'text/css', :test, TestCompressor

    # Necessary for tests on Rails 7
    ActiveSupport::Dependencies.autoload_paths = []
    ActiveSupport::Dependencies.autoload_once_paths = []

    ::Rails.application = @app
    ::Rails.backtrace_cleaner.remove_silencers!
  end

  def teardown
    directory = "#{Rails.root}/tmp"
    FileUtils.remove_dir(directory) if File.directory?(directory)
  end

  def render_asset(asset)
    app.assets[asset].to_s
  end

  def initialize!
    Rails.env = 'test'
    @app.initialize!
  end

  def initialize_dev!
    Rails.env = 'development'
    @app.initialize!
  end

  def initialize_prod!
    Rails.env = 'production'
    @app.initialize!
  end

  def test_setup_works
    initialize_dev!

    asset = render_asset('application.css')
    assert_equal <<~CSS, asset
      .hello {
        color: #FFF;
      }
    CSS
  end

  def test_raises_sassc_syntax_error
    initialize!

    assert_raises(SassC::SyntaxError) do
      render_asset('syntax_error.css')
    end
  end

  def test_all_sass_asset_paths_work
    initialize!

    css_output = render_asset('helpers_test.css')

    assert_match %r{asset-path:\s*"/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e\.png"},
                 css_output, 'asset-path:\s*"/assets/rails.png"'
    assert_match %r{asset-url:\s*url\(/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e\.png\)},
                 css_output, 'asset-url:\s*url\(/assets/rails.png\)'
    assert_match %r{image-path:\s*"/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e\.png"},
                 css_output, 'image-path:\s*"/assets/rails.png"'
    assert_match %r{image-url:\s*url\(/assets/rails-322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e\.png\)},
                 css_output, 'image-url:\s*url\(/assets/rails.png\)'
  end

  def test_sass_asset_paths_work
    initialize!

    css_output = render_asset('helpers_test.css')

    assert_match %r{video-path:\s*"/videos/rails.mp4"}, css_output, 'video-path:\s*"/videos/rails.mp4"'
    assert_match %r{video-url:\s*url\(/videos/rails.mp4\)}, css_output, 'video-url:\s*url\(/videos/rails.mp4\)'
    assert_match %r{audio-path:\s*"/audios/rails.mp3"}, css_output, 'audio-path:\s*"/audios/rails.mp3"'
    assert_match %r{audio-url:\s*url\(/audios/rails.mp3\)}, css_output, 'audio-url:\s*url\(/audios/rails.mp3\)'
    assert_match %r{font-path:\s*"/fonts/rails.ttf"}, css_output, 'font-path:\s*"/fonts/rails.ttf"'
    assert_match %r{font-url:\s*url\(/fonts/rails.ttf\)}, css_output, 'font-url:\s*url\(/fonts/rails.ttf\)'
    assert_match %r{font-url-with-query-hash:\s*url\(/fonts/rails.ttf\?#iefix\)}, css_output,
                 'font-url:\s*url\(/fonts/rails.ttf?#iefix\)'
    assert_match %r{javascript-path:\s*"/javascripts/rails.js"}, css_output,
                 'javascript-path:\s*"/javascripts/rails.js"'
    assert_match %r{javascript-url:\s*url\(/javascripts/rails.js\)}, css_output,
                 'javascript-url:\s*url\(/javascripts/rails.js\)'
    assert_match %r{stylesheet-path:\s*"/stylesheets/rails.css"}, css_output,
                 'stylesheet-path:\s*"/stylesheets/rails.css"'
    assert_match %r{stylesheet-url:\s*url\(/stylesheets/rails.css\)}, css_output,
                 'stylesheet-url:\s*url\(/stylesheets/rails.css\)'

    asset_data_url_regexp = /asset-data-url:\s*url\((.*?)\)/
    assert_match asset_data_url_regexp, css_output, 'asset-data-url:\s*url\((.*?)\)'
    asset_data_url_match = css_output.match(asset_data_url_regexp)[1]
    asset_data_url_expected = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw%' \
                              '2FeHBhY2tldCBiZWdpbj0i77u%2FIiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYxIDY0LjE0MDk0OSwgMjA' \
                              'xMC8xMi8wNy0xMDo1NzowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRw' \
                              'Oi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDc' \
                              'mVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNS4xIE1hY2ludG9zaCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCNzY5NDE1QkQ2NkMxMUUwOUUzM0E5Q0E2RTgyQUExQiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCNzY5NDE1Q0' \
                              'Q2NkMxMUUwOUUzM0E5Q0E2RTgyQUExQiI%2BIDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkE3MzcyNTQ2RDY2QjExRTA5RTMzQTlDQTZFODJBQTFCIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkI3Njk0M' \
                              'TVBRDY2QzExRTA5RTMzQTlDQTZFODJBQTFCIi8%2BIDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY%2BIDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8%2B0HhJ9AAAABBJREFUeNpi%2BP%2F%2FPwNAgAEACPwC%2FtuiTRYAAAAA' \
                              'SUVORK5CYII%3D'
    assert_equal asset_data_url_expected, asset_data_url_match
  end

  def test_sass_imports_work_correctly
    app.config.sass.load_paths << Rails.root.join('app/assets/stylesheets/in_load_paths')
    initialize!

    css_output = render_asset('imports_test.css')
    assert_match(/main/,                     css_output)
    assert_match(/top-level/,                css_output)
    assert_match(/partial-sass/,             css_output)
    assert_match(/partial-scss/,             css_output)
    assert_match(/not-a-partial/,            css_output)
    assert_match(/sub-folder-relative-sass/, css_output)
    assert_match(/sub-folder-relative-scss/, css_output)
    assert_match(/plain-old-css/,            css_output)
    assert_match(/another-plain-old-css/,    css_output)
    assert_match(/without-css-ext/,          css_output)
    assert_match(/css-scss-handler/,         css_output)
    assert_match(/css-sass-handler/,         css_output)
    assert_match(/css-erb-handler/,          css_output)
    assert_match(/scss-erb-handler/,         css_output)
    assert_match(/sass-erb-handler/,         css_output)

    # TODO: Loading a partial with a custom file extension (.foo)
    # appears to have broken since the original.
    refute_match(/partial-foo/,              css_output)

    # Do these two actually test anything?
    # should the extension be changed?
    assert_match(/css-sass-erb-handler/,     css_output)
    assert_match(/css-scss-erb-handler/,     css_output)
    assert_match(/default-old-css/,          css_output)
    assert_match(/globbed/,                  css_output)
    assert_match(/nested-glob/,              css_output)
    assert_match(/partial_in_load_paths/,    css_output)
  end

  def test_sass_uses_work_correctly
    path = Rails.root.join('app/assets/stylesheets/partials/subfolder/_relative_sass.sass')
    original_data = File.read(path)

    app.config.sass.load_paths << Rails.root.join('app/assets/stylesheets/in_load_paths')
    initialize!

    css_output = render_asset('uses_test.css')
    assert_match(/main/,                     css_output)
    assert_match(/background-color:red/,     css_output)
    assert_match(/partial-scss/,             css_output)
    assert_match(/sub-folder-relative-sass/, css_output)
    assert_match(/not-a-partial/,            css_output)

    # mutate nested dependency
    File.open(path, 'a') do |file|
      file.puts <<~SASS

        .sub-folder-dependency-modified
          width: 10px
      SASS
    end

    css_output = render_asset('uses_test.css')
    assert_match(/sub-folder-dependency-modified/, css_output)
  ensure
    File.write(path, original_data)
  end

  def test_style_config_item_is_defaulted_to_nil_in_development_mode
    initialize_dev!
    assert_nil Rails.application.config.sass.style
  end

  def test_style_config_item_is_honored
    @app.config.sass.style = :nested
    initialize!
    assert_equal :nested, Rails.application.config.sass.style
  end

  def test_context_is_being_passed_to_erb_render
    initialize!

    css_output = render_asset('erb_render_with_context.css.erb')
    assert_match(/@font-face/, css_output)
  end

  def test_special_characters_compile
    initialize!
    render_asset('special_characters.css')
  end

  def test_css_compressor_config_item_is_honored_if_not_development_mode
    @app.config.assets.css_compressor = :test
    initialize_prod!
    assert_equal :test, Rails.application.config.assets.css_compressor
  end

  def test_css_compressor_config_item_may_be_nil_in_test_mode
    @app.config.assets.css_compressor = nil
    initialize!
    assert_nil Rails.application.config.assets.css_compressor
  end

  def test_css_compressor_is_defined_in_test_mode
    initialize!
    assert_equal :sass, Rails.application.config.assets.css_compressor
  end

  def test_css_compressor_is_defined_in_prod_mode
    initialize_prod!
    assert_equal :sass, Rails.application.config.assets.css_compressor
  end

  def test_compression_works_for_scss_in_prod_mode
    initialize_prod!

    asset = render_asset('application.css')
    assert_equal <<~CSS, asset
      .hello{color:#fff}
    CSS
  end

  def test_compression_works_for_css_in_prod_mode
    initialize_prod!

    asset = render_asset('plain_css.css')
    assert_equal <<~CSS, asset
      .goodbye{color:#fff}
    CSS
  end

  def test_compression_disabled_for_css_in_dev_mode
    initialize_dev!

    asset = render_asset('plain_css.css')
    assert_equal <<~CSS, asset
      .goodbye {
        color: #FFF;
      }
    CSS
  end

  def test_scss_compression_is_used_in_prod_mode
    engine1 = stub(render: 'foo', dependencies: [])
    engine2 = stub(render: 'bar')
    SassC::Engine.expects(:new).once.returns(engine1)
    SassC::Engine.expects(:new).once.with("foo\n", { style: :compressed }).returns(engine2)

    initialize_prod!
    render_asset('application.css')
  end

  def test_css_compression_is_used_in_prod_mode
    engine = stub(render: '')
    SassC::Engine.expects(:new).once.with(".goodbye {\n  color: #FFF;\n}\n", { style: :compressed }).returns(engine)

    initialize_prod!
    render_asset('plain_css.css')
  end

  def test_allows_for_inclusion_of_inline_source_maps
    @app.config.sass.inline_source_maps = true
    initialize_dev!

    asset = render_asset('application.css')
    assert_match(/.hello/, asset)
    assert_match(/sourceMappingURL/, asset)
  end

  def test_globbed_imports_work_with_multiple_extensions
    initialize!

    asset = render_asset('glob_multiple_extensions_test.css')
    assert_equal <<~CSS, asset
      .glob{margin:0}
    CSS
  end

  def test_globbed_imports_work_when_globbed_file_is_added
    new_file = File.join(File.dirname(__FILE__), 'dummy', 'app', 'assets', 'stylesheets', 'globbed', 'new_glob.scss')

    initialize!

    css_output = render_asset('glob_test.css')
    refute_match(/new-file-test/, css_output)

    File.open(new_file, 'w') do |file|
      file.puts '.new-file-test { color: #000; }'
    end

    Rails.application.assets.cache.clear
    new_css_output = render_asset('glob_test.css')
    assert_match(/new-file-test/, new_css_output)
    refute_equal css_output, new_css_output
  ensure
    File.delete(new_file)
  end

  def test_globbed_imports_work_when_globbed_file_is_changed
    new_file = File.join(File.dirname(__FILE__), 'dummy', 'app', 'assets', 'stylesheets', 'globbed', 'new_glob.scss')

    initialize!

    File.open(new_file, 'w') do |file|
      file.puts '.new-file-test { color: #000; }'
    end

    css_output = render_asset('glob_test.css')
    assert_match(/new-file-test/, css_output)
    refute_match(/changed-file-test/, css_output)

    File.open(new_file, 'a') do |file|
      file.puts '.changed-file-test { color: #000; }'
    end

    Rails.application.assets.cache.clear
    new_css_output = render_asset('glob_test.css')
    assert_match(/new-file-test/, new_css_output)
    assert_match(/changed-file-test/, new_css_output)
    refute_equal css_output, new_css_output
  ensure
    File.delete(new_file)
  end

  class TestCompressor
    def self.call(*)
    end
  end
end
