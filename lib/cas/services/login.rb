module Cas::Services
  class Login
    attr_reader :ticket

    def call
      @ticket = LoginTicket.new(name: "LT-#{Digest::SHA1.hexdigest(Time.new.to_s)}")
      @ticket.save
    end
  end
end
