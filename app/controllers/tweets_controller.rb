class TweetsController < ApplicationController

    get '/tweets' do
        if is_logged_in?
            @tweets = Tweet.all 
            erb :'tweets/tweets'
        else
            redirect "/login"
        end       
    end    

    get '/tweets/new' do
        if is_logged_in?
            erb :'/tweets/new'
        else
            redirect '/login'
        end        
    end

    post '/tweets' do
        if is_logged_in?
              if params[:content].empty?
                redirect "/tweets/new"
              else
                
                @tweet=Tweet.create(:content => params[:content])
                @tweet.user = current_user
                @tweet.save
                redirect "/tweets/#{@tweet.id}"
              end    
             
        else
            redirect "/tweets/new"
        end        

    end

    get '/tweets/:id' do
      if is_logged_in? 
         @tweet = Tweet.find_by_id(params[:id])
         erb :'tweets/show_tweet'
      else
        redirect '/login'
      end   

    end

    delete '/tweets/:id/delete' do
        if is_logged_in? 
            @tweet= Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user == current_user
               @tweet.delete
            end    
            redirect "/tweets"
        else
            redirect "/login"
        end
    end

    get '/tweets/:id/edit' do
        if is_logged_in? 
             @tweet=Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user == current_user
              erb :'tweets/edit_tweet'
            else 
                redirect "/tweets"  
            end  
        else
                redirect "/login"
        end
    end 

    patch '/tweets/:id' do
        if is_logged_in? 
           
            @tweet=Tweet.find_by_id(params[:id])
            if params[:content].empty?
                redirect "/tweets/#{params[:id]}/edit"
            else   
                if @tweet && @tweet.user == current_user  
                      
                        @tweet.update(:content => params[:content])
                        redirect "/tweets/#{@tweet.id}" 
                else
                        redirect "/tweets/#{@tweet.id}/edit" 
                end           
            end
        else
            redirect "/login"
        end        
    end

end
