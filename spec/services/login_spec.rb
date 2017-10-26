require "spec_helper"

module Cas::Services
  RSpec.describe "Login" do
    let(:user) { spawn_user }

    it "generates a login ticket for a fresh login attempt" do
      service = Login.new
      service.call

      expect(service.ticket).to be_a_kind_of(LoginTicket)
    end

    describe "given an existing login ticket" do
      attr_reader :login_ticket

      before do
        @login_ticket = spawn_login_ticket
      end

      it "expires a login ticket after an unsuccessful auth attempt" do
        lt = login_ticket.name

        service = Login.new(
          username: "bad_user",
          password: "bad_password",
          login_ticket_name: lt,
          service: "http://app.example.com"
        )

        service.call
        expect(login_ticket.reload.active).to be_falsey
      end
    end
  end
end

private

def spawn_user(email: "test@example.com", password: "password")
  service = Cas::Services::Signup.new(email: email, password: email)
  service.call
  service.user
end

def spawn_login_ticket
  service = Cas::Services::Login.new
  service.call
  service.ticket
end
