class UsersController < ApplicationController

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'users/show'
    end

    get '/login' do

        if !is_logged_in?
          erb :'users/login'
        else
          redirect "/tweets"
        end

    end


    post '/login' do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/tweets"
        else
            redirect "/signup"    
        end
    end

   get '/signup' do
         if is_logged_in?
            redirect '/tweets'
         else
            erb :'users/create_user'
         end

   end

   post '/signup' do

       if !params[:username].empty?  &&  !params[:email].empty? && !params[:password].empty?
         @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
         session[:user_id]= @user.id
         redirect '/tweets'
       else
        redirect "/signup"
       end
   end

   get '/logout' do
            if is_logged_in?
                session.destroy
            end
            redirect "/login"
    end


end
