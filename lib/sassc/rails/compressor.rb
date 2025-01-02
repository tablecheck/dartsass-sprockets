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
      @cache_key = SecureRandom.uuid
    end

    def call(*args)
      SassC::Engine.new(args[0][:data], { style: :compressed }).render
    end
  end
end
