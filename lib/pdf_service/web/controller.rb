# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/streaming'
require 'securerandom'
require 'uri'
require 'net/http'

module PdfService
  module Web
    class Controller < Sinatra::Base
      set :root, File.join(File.dirname(__FILE__), '..', '..', '..')
      set :views, settings.root + '/views'
      helpers Sinatra::Streaming

      ALLOWED_HOSTS = ['eltern-sgh.de', 'geb-herrenberg.de', 'freunde-sgh.de',].freeze

      get '/' do
        url = URI(params[:url] || '')

        erb :index, layout: true, locals: {
          title: 'Hello',
          url: url,
        }
      end

      post '/' do
        protected! unless whitelisted(params[:url])

        uri = URI("http://electron-renderer:3000/pdf?accessKey=#{ENV.fetch('RENDERER_ACCESS_KEY')}&url=#{params[:url]}")
        content_type 'application/pdf'

        stream do |out|
          Net::HTTP.get_response(uri) do |res|
            res.read_body do |segment|
              out << segment
              warn "#{uri}: #{out.pos} bytes written"
            end
          end
        end
      end

      # async
      # post '/' do
      #   status 201
      #   job_id = SecureRandom.uuid
      #   redirect to("/status/#{job_id}")
      # end
      #
      # get %r{/status/([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})} do |job_id|
      #   erb :status, layout: true, locals: {
      #     title: "Status for #{job_id}",
      #     status: 'submitted',
      #   }
      # end

      def whitelisted(url)
        hostname_tld = URI(url).host.split('.')[-2..-1].join('.')
        ALLOWED_HOSTS.include?(hostname_tld)
      end

      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && !@auth.credentials.first.empty?
      end
    end
  end
end
