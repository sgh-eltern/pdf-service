# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/streaming'

require 'pdf_service/streaming_client'

module PdfService
  module Web
    class Controller < Sinatra::Base
      set :root, File.join(File.dirname(__FILE__), '..', '..', '..')
      set :views, settings.root + '/views'
      set :render_service, StreamingClient.new

      helpers Sinatra::Streaming

      configure :production, :development do
        enable :logging
      end

      ALLOWED_HOSTS = ['eltern-sgh.de', 'geb-herrenberg.de', 'freunde-sgh.de',].freeze

      get '/' do
        url = URI(params[:url] || '')
        logger.info "Starting with #{url}"

        erb :index, layout: true, locals: {
          title: 'PDF-Service',
          url: url,
        }
      end

      post '/' do
        url_to_print = params[:url]
        halt 422, "Error: Mandatory parameter 'url' is missing" if url_to_print.empty?
        protected! unless whitelisted(url_to_print)

        content_type 'application/pdf'

        stream do |out_stream|
          settings.render_service.stream(url_to_print) do |segment|
            out_stream << segment
            logger.info "bytes written: #{out_stream.pos}"
          end
        end
      end

      def whitelisted(url)
        hostname_tld = URI(url).host.split('.')[-2..-1].join('.')
        ALLOWED_HOSTS.include?(hostname_tld)
      end

      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, 'Not authorized'
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && !@auth.credentials.first.empty?
      end
    end
  end
end
