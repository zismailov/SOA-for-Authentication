# frozen_string_literal: true

require 'spec_helper'

module Cas::Services
  RSpec.describe 'Signup' do
    attr_reader :service

    before do
      @service = Signup.new(email: 'test@example.com', password: 'password')
      service.call
    end

    it 'encrypts the password' do
      expect(service.user.encrypted_password.length).to be > 32
    end

    it 'saves the user' do
      expect(service.user.id).not_to be_nil
    end

    it 'has a created_at timestamp' do
      expect(service.user.created_at).to be < Time.now
    end

    it 'signs a user up' do
      expect(service.status).to eq(:ok)
    end
  end
end
