enable :sessions

post '/urls' do
  byebug
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