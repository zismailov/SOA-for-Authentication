# frozen_string_literal: true

module Helpers
  def spawn_user(email: 'test@example.com', password: 'password')
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
    tgt = TicketGrantingTicket.new(name: 'TGT-random', user: user)
    tgt.save
    tgt
  end

  def spawn_service_ticket(service: nil, user: nil)
    st = ServiceTicket.new(name: 'ST-random', service: service, user: user)
    st.save
    st
  end

  def perform_login(user: nil, service: nil)
    ticket = spawn_login_ticket
    post '/login',
         username: user.email,
         password: 'password',
         lt: ticket.name,
         service: service

    @service_ticket = CGI.parse(URI.parse(last_response.header['Location']).query)['ticket'][0]
  end
end
