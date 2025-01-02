# frozen_string_literal: true

require 'sprockets/version'
require 'sprockets/sass_processor'
require 'sprockets/utils'
require 'sprockets/uri_utils'

module SassC
  module Rails
    class SassTemplate < Sprockets::SassProcessor
      def initialize(options = {}, &block) # rubocop:disable Lint/MissingSuper
        @cache_version = options[:cache_version]
        @cache_key = "#{self.class.name}:#{VERSION}:#{::SassC::VERSION}:#{@cache_version}"
        @importer_class = options[:importer] || ::SassC::Rails::Importer
        @sass_config = options[:sass_config] || {}
        @functions = Module.new do
          include ::SassC::Script::Functions
          include Functions
          include options[:functions] if options[:functions]
          class_eval(&block) if block_given?
        end
      end

      def call(input)
        context = input[:environment].context_class.new(input)

        options = {
          filename: input[:filename],
          line_comments: line_comments?,
          syntax: self.class.syntax,
          load_paths: input[:environment].paths,
          functions: @functions,
          importer: @importer_class,
          quiet_deps: ::Rails.application.config.sass.quiet_deps,
          sprockets: {
            context: context,
            environment: input[:environment],
            dependencies: context.metadata[:dependency_paths]
          }
        }.merge!(config_options) { |key, left, right| safe_merge(key, left, right) }

        engine = ::SassC::Engine.new(input[:data], options)

        css = engine.render

        # Track all imported files
        sass_dependencies = Set.new([input[:filename]])
        engine.dependencies.map do |dependency|
          sass_dependencies << dependency.options[:filename]
          context.metadata[:dependencies] << Sprockets::URIUtils.build_file_digest_uri(dependency.options[:filename])
        end

        context.metadata.merge(data: css, sass_dependencies: sass_dependencies)
      end

      def config_options
        opts = { style: sass_style, load_paths: load_paths }

        if ::Rails.application.config.sass.inline_source_maps
          opts.merge!(source_map_file: '.',
                      source_map_embed: true,
                      source_map_contents: true)
        end

        opts
      end

      def sass_style
        (::Rails.application.config.sass.style || :expanded).to_sym
      end

      def load_paths
        ::Rails.application.config.sass.load_paths || []
      end

      def line_comments?
        ::Rails.application.config.sass.line_comments
      end

      def safe_merge(_key, left, right)
        if [left, right].all? { |v| v.is_a? Hash }
          left.merge(right) { |k, l, r| safe_merge(k, l, r) }
        elsif [left, right].all? { |v| v.is_a? Array }
          (left + right).uniq
        else
          right
        end
      end

      # The methods in the Functions module were copied here from sprockets in order to
      # override the Value class names (e.g. ::SassC::Script::Value::String)
      module Functions
        def asset_path(path, options = {})
          path = path.value

          path, _, query, fragment = URI.split(path)[5..8]
          path     = sprockets_context.asset_path(path, options)
          query    = "?#{query}" if query
          fragment = "##{fragment}" if fragment

          ::SassC::Script::Value::String.new("#{path}#{query}#{fragment}", :string)
        end

        def asset_url(path, options = {})
          ::SassC::Script::Value::String.new("url(#{asset_path(path, options).value})")
        end

        def asset_data_url(path)
          url = sprockets_context.asset_data_uri(path.value)
          ::SassC::Script::Value::String.new("url(#{url})")
        end
      end
    end

    class ScssTemplate < SassTemplate
      def self.syntax
        :scss
      end
    end
  end
end
