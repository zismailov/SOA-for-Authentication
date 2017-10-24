class App < Sinatra::Base
  get "/" do
    @users = User.all
    erb :index
  end

  get "/users/new" do
    erb :signup
  end

  post "/users" do
    service = Cas::Services::Signup.new(email: params[:user][:email], password: params[:user][:password])
    service.call

    if service.status == :ok
      redirect "/"
    end
  end
end
