# frozen_string_literal: true

require 'spec_helper'

module Cas::Services
  RSpec.describe 'Validate' do
    let(:service) { 'https://app.example.com' }
    let(:user) { spawn_user }
    let(:service_ticket) { spawn_service_ticket service: service, user: user }
    let(:validate_service) { Validate.new(service, service_ticket.name) }

    before do
      validate_service.call
    end

    it 'validates a service ticket against a service' do
      expect(validate_service.status).to eq(:ok)
    end

    it "returns the user's info on successful validation" do
      expect(validate_service.user).to be_a_kind_of(User)
    end
  end
end
