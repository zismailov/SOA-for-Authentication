# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require 'sinatra'
require 'cas/app/app' # sinatra app

RSpec.describe 'Request validate' do
  include Rack::Test::Methods

  let(:app) { App }
  let(:user) { spawn_user email: 'test@example.com', password: 'password' }
  let(:service) { 'https://app.example.com' }

  before do
    clear_cookies
    perform_login(user: user, service: service)
  end

  it 'validates a service ticket for a service' do
    get '/p3/serviceValidate', service: service, ticket: @service_ticket
    expect(last_response.status).to eq(200)
  end

  it 'returns an XML response' do
    get '/p3/serviceValidate', service: service, ticket: @service_ticket
    expect(last_response.content_type).to match %r{application/xml}
  end
end
