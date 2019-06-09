# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'pdf_service/web/controller'

run Rack::URLMap.new(
  '/' => PdfService::Web::Controller
)
