require 'rack-flash'

class UsersController < ApplicationController

 use Rack::Flash


 get '/register' do
   if logged_in?

     redirect "/users/#{@user.id}"

   else
     erb :'/users/register'
   end
 end


 post '/register' do
   @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])

  if  @user.save
    @user.save
   session[:user_id] = @user.id
   redirect "/users/#{@user.id}"

 else
   flash[:message] = "Please fill out all the required fields"
   redirect '/register'
 end
end

get '/login' do
  if logged_in?
    redirect '/trails'
   flash[:message] = "Welcome Back, #{@user.username}!"
  else
    erb :'/users/login'
  end
end
 post '/login' do
   @user = User.find_by(:username => params[:username])
   if @user && @user.authenticate(params[:password])

     session[:user_id] = @user.id

     flash[:message] = "Welcome Back, #{@user.username}!"
     redirect "/users/#{@user.id}"

   else
     flash[:message] = "The username and password is incorrect. Please try again."
     redirect '/login'
   end
 end


  get '/users/:id' do
    @user = User.find_by_id(params[:id])
    @user = current_user
      erb :'/users/show'

    end

get '/logout' do
  if logged_in?
    session.clear
    flash[:message] = "You have been logged out of your account."
    redirect '/'

end
end




end #of class
