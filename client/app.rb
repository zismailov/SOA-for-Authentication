require 'pry'
class App < Sinatra::Base
  get '/' do
    erb :index
  end

  enable :sessions

  before do
    @server = 'http://localhost:1234'
    @client = 'http://localhost:4567'

    check_service_ticket
  end

  get '/protected' do
    authenticate_user!
    @user = current_user
    erb :protected
  end

  private

  def authenticate_user!
    return if logged_in?
    if service_ticket?
      validate
    else
      login
    end
  end

  def logged_in?
    current_user
  end

  def current_user
    session[:user]
  end

  def service_ticket?
    params[:ticket]
  end

  def login
    redirect "#{@server}/login?service=#{@client}"
  end

  def validate
    hash = {
      service: @client,
      ticket:  params[:ticket]
    }
    xml_response = HTTParty.get("#{@server}/p3/serviceValidate?#{parameterize(hash)}").body
    xml = Nokogiri::XML xml_response

    if xml.xpath('//cas:authenticationSuccess')
      session[:user] = { email: xml.xpath('//cas:user').text }
      redirect '/'
    else
      @error = xml.xpath('//cas:authenticationFailure').text
    end
  end

  def parameterize(hash)
    hash.map { |key, value| "#{key}=#{value}" }.join '&'
  end

  def check_service_ticket
    validate if service_ticket?
  end
end
