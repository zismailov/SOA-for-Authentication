# frozen_string_literal: true

class App < Sinatra::Base
  get '/' do
    @users = User.all
    erb :index
  end

  get '/users/new' do
    erb :signup
  end

  post '/users' do
    service = Cas::Services::Signup.new(email: params[:user][:email], password: params[:user][:password])
    service.call

    redirect '/' if service.status == :ok
  end
end
