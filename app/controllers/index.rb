enable :sessions

helpers do
  def current_user
    if session[:user]
      User.find session[:user]
    else
      nil
    end
  end

  def logged_in?
    if current_user
      true
    else
      false
    end
  end
end

get '/' do
  if logged_in?
    redirect '/home'
  else
  erb :index
  end
end

post '/login' do
  @user = User.authenticate(params[:username_or_email], params[:password])
  session[:user] = @user.id

  if @user
    redirect '/home'
  else
    redirect '/error'
  end
end

get '/error' do
  erb :error
end

post '/register' do
  @user = User.new(params[:user])
  if @user.save
    session[:user] = @user.id
    redirect '/home'
  else
    erb :index
  end
end

get '/home' do
  if session[:user]
    @user = User.find session[:user]
    erb :home
  else
    redirect '/access_denied'
  end
end

delete '/logout' do
  session[:user] = nil
  redirect '/'
end

get '/access_denied' do
  erb :access_denied
end

get '/user/:id' do
  @user = User.find(params[:id])
  erb :profile
end

post '/urls' do
  if current_user
    @user = User.find session[:user]
    @url = @user.urls.create(long_url: params[:long_url])
  else
    @url = Url.create(long_url: params[:long_url])
  end

  @short_url = @url.short_url

  erb :short_url
end

get '/:short_url' do
  @url = Url.where(short_url: params[:short_url]).first
  redirect @url.long_url
end