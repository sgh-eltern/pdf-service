# frozen_string_literal: true

require 'spec_helper'
require 'pdf_service/web/controller'

describe PdfService::Web::Controller do
  include Rack::Test::Methods

  def app
    PdfService::Web::Controller
  end

  it 'has a root page' do
    get '/'
    expect(last_response).to be_ok
  end
end
