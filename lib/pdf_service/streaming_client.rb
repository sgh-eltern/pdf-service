# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'logger'

module PdfService
  class StreamingClient
    def initialize(logger=default_logger)
      @logger = logger
    end

    def stream(url)
      renderer_url = renderer_url(url)
      logger.info "Rendering #{renderer_url}"

      Net::HTTP.get_response(renderer_url) do |renderer_response|
        logger.info "Renderer response code: #{renderer_response.code}"

        renderer_response.read_body do |segment|
          yield segment
        end
      end
    end

    private

    attr_reader :logger

    def default_logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
      logger
    end

    def renderer_url(url_to_print)
      renderer_host = ENV.fetch('RENDERER_HOST', 'electron-renderer')
      URI("http://#{renderer_host}:3000/pdf?accessKey=#{ENV.fetch('RENDERER_ACCESS_KEY')}&url=#{url_to_print}")
    end
  end
end
