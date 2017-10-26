module Cas::Services
  class Login
    attr_reader :ticket

    def initialize(username: nil, password: nil, login_ticket_name: nil, service: nil)
      @username = username
      @password = password
      @login_ticket_name = login_ticket_name
      @service = service
    end

    def call
      if @username.nil?
        generate_login_ticket
      else
        login
      end
    end

    private

    def generate_login_ticket
      @ticket = LoginTicket.new(name: "LT-#{Digest::SHA1.hexdigest(Time.new.to_s)}")
      @ticket.save
    end

    def login
      if !valid_auth?
        expire_login_ticket
      end
    end

    def valid_auth?
      User.where(email: @username, encrypted_password: Digest::SHA1.hexdigest(@password)).first
    end

    def expire_login_ticket
      LoginTicket.where(name: @login_ticket_name).first.update_attribute(:active, false)
    end
  end
end
