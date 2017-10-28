# frozen_string_literal: true

class App < Sinatra::Base
  get '/' do
    @users = User.all
    erb :index
  end

  get '/login' do
    if ticket_granting_ticket?
      service = Cas::Services::Login.new(ticket_granting_ticket_name: request.cookies['CASTGC'])
      service.call
      if params[:service]
        redirect params[:service] + "?ticket=#{service.service_ticket.name}", 303
      end
    else
      service = Cas::Services::Login.new
      service.call
      @service = params[:service]
      @lt = service.ticket.name
      erb :login
    end
  end

  post '/login' do
    if all_inputs_present?
      service = Cas::Services::Login.new(
        username: params[:username],
        password: params[:password],
        login_ticket_name: params[:lt],
        service: params[:service]
      )
      service.call

      if service.status == :ok
        response.set_cookie 'CASTGC', value: service.ticket_granting_ticket.name
        if params[:service]
          redirect params[:service] + "?ticket=#{service.service_ticket.name}", 303
        end
      end
    else
      status 422
    end
  end

  get '/users/new' do
    erb :signup
  end

  post '/users' do
    service = Cas::Services::Signup.new(email: params[:user][:email], password: params[:user][:password])
    service.call

    redirect '/' if service.status == :ok
  end

  private

  def all_inputs_present?
    params[:username] && params[:password] && params[:lt] &&
      params[:username] != '' && params[:password] != '' && params[:lt] != ''
  end

  def ticket_granting_ticket?
    !request.cookies['CASTGC'].nil? && TicketGrantingTicket.where(name: request.cookies['CASTGC']).first
  end
end
