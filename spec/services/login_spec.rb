require "spec_helper"

module Cas::Services
  RSpec.describe "Login" do
    let(:user) { spawn_user }

    it "generates a login ticket for a fresh login attempt" do
      service = Login.new
      service.call

      expect(service.ticket).to be_a_kind_of(LoginTicket)
    end

    it "logs a user in based off an existing session" do
      ticket_granting_ticket = spawn_ticket_granting_ticket(user: user)
      service = Login.new(
        ticket_granting_ticket_name: ticket_granting_ticket.name,
        service: "https://app.example.com"
      )
      service.call

      expect(service.status).to eq(:ok)
    end

    it "provides a service ticket based off a ticket granting cookie auth attempt" do
      ticket_granting_ticket = spawn_ticket_granting_ticket(user: user)
      service = Login.new(
        ticket_granting_ticket_name: ticket_granting_ticket.name,
        service: "https://app.example.com"
      )
      service.call

      expect(service.service_ticket).to be_a_kind_of(ServiceTicket)
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

      it "generates a ticket granting ticket after a successful auth attempt" do
        lt = login_ticket.name
        service = Login.new(
          username: user.email,
          password: "password",
          login_ticket_name: lt,
          service: "https://app.example.com"
        )

        service.call
        expect(service.ticket_granting_ticket).to be_a_kind_of(TicketGrantingTicket)
      end

      it "generates a service ticket after a successful auth attempt" do
        lt = login_ticket.name

        service = Login.new(
          username: user.email,
          password: "password",
          login_ticket_name: lt,
          service: "https://app.example.com"
        )

        service.call
        expect(service.service_ticket).to be_a_kind_of(ServiceTicket)
      end
    end
  end
end

private

def spawn_user(email: "test@example.com", password: "password")
  service = Cas::Services::Signup.new(email: email, password: password)
  service.call
  service.user
end

def spawn_login_ticket
  service = Cas::Services::Login.new
  service.call
  service.ticket
end

def spawn_ticket_granting_ticket(user: nil)
  tgt = TicketGrantingTicket.new(name: "TGT-random", user: user)
  tgt.save
  tgt
end
