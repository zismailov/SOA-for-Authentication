# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require 'sinatra'
require 'cas/app/app' # sinatra app

RSpec.describe 'Request' do
  include Rack::Test::Methods

  let(:app) { App }
  let(:username) { 'test@example.com' }
  let(:password) { 'password' }
  let(:service) { 'https://app.example.com' }

  before { clear_cookies }

  describe 'cold login' do
    it 'allows to login' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    # it 'provides a login ticket' do
    #   get '/login'
    #   expect(last_response.body).to have_field("<input name='lt' type='hidden' value='LT-")
    # end

    it 'requires a username do be passed in' do
      post '/login', password: password, lt: 'LT-random'

      expect(last_response.status).to eq(422)
    end

    it 'requires a password do be passed in' do
      post '/login', username: username, lt: 'LT-random'

      expect(last_response.status).to eq(422)
    end

    it 'requires a login ticket do be passed in' do
      post '/login', username: username, password: 'password'

      expect(last_response.status).to eq(422)
    end

    describe 'given a specific user' do
      before do
        @user = spawn_user(email: username, password: password)
        @login_ticket = spawn_login_ticket
      end

      it 'sends the ticket granting ticket on a successful auth attempt' do
        post '/login',
             username: username,
             password: password,
             lt: @login_ticket.name
        expect(rack_mock_session.cookie_jar['CASTGC']).not_to be_nil
      end

      it 'sends the service ticket on a successful auth attempt' do
        post '/login',
             username: username,
             password: password,
             lt: @login_ticket.name,
             service: service
        expect(last_response.header['Location']).to match(/(\?|&)ticket=ST-\w+/)
      end

      it 'redirects to a service on a successful auth attempt' do
        post '/login',
             username: username,
             password: password,
             lt: @login_ticket.name,
             service: service
        expect(last_response.status).to eq(303)
        expect(last_response.header['Location']).to match(/^#{service}/)
      end
    end
  end

  describe 'warm login (there is already a ticket granting cookie)' do
    it 'logs a user in base off the cookie' do
      user = spawn_user(email: username, password: password)
      perform_login(user: user, service: 'https://app.example.com')
      get '/login', service: 'https://app.example.com'
      expect(last_response.status).to eq(303)
    end
  end
end
