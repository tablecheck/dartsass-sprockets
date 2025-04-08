# frozen_string_literal: true

require 'sprockets/sass_compressor'
require 'securerandom'

module Sprockets
  class SassCompressor
    def initialize(options = {})
      @options = {
        syntax: :scss,
        cache: false,
        read_cache: false,
        style: :compressed
      }.merge(options).freeze

      ver1 = SassC::Rails::VERSION
      ver2 = SassC::Embedded::VERSION if defined?(SassC::Embedded::VERSION)
      @cache_key = "#{self.class.name}:#{ver1}:#{ver2}:#{Sprockets::DigestUtils.digest(options)}".freeze
    end

    def call(*args)
      SassC::Engine.new(args[0][:data], { style: :compressed }).render
    end
  end
end
