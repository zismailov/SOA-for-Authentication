require "spec_helper"

module Cas::Services
  RSpec.describe "Login" do
    let(:user) { spawn_user }

    it "generates a login ticket for a fresh login attempt" do
      service = Login.new
      service.call

      expect(service.ticket).to be_a_kind_of(LoginTicket)
    end
  end
end

private

def spawn_user(email: "test@example.com", password: "password")
  service = Cas::Services::Signup.new(email: email, password: email)
  service.call
  service.user
end
