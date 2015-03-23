enable :sessions

post '/login' do
  byebug
  @user = User.authenticate(params[:username_or_email], params[:password])
  if @user
    session[:user] = @user.id
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
