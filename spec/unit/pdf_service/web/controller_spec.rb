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

  context 'requesting a PDF' do
    context 'with a URL that is NOT whitelisted' do
      let(:url_to_render) { 'http://example.com' }

      it 'responds with a basic auth challenge' do
        post '/', url: url_to_render
        expect(last_response.status).to eq(401)
      end
    end

    context 'with a whitelisted URL' do
      let(:url_to_render) { 'http://www.eltern-sgh.de/infocenter/leitfaden/' }

      before do
        expect_any_instance_of(PdfService::StreamingClient).to receive(:stream).with(url_to_render)
      end

      it 'responds with a PDF' do
        post '/', url: url_to_render

        expect(last_response).to be_ok
        expect(last_response.content_type).to eq('application/pdf')
      end
    end
  end
end
