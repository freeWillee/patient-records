class ApplicationController < Sinatra::Base
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "mypassword"
    end

    get '/' do
        redirect '/patients'
    end

    helpers do
        def logged_in?
            !!current_user
        end

        def current_user
            @current_user ||= User.find_by(:username => session[:username]) if session[:username]
        end

        def login(username, password)
            #check to see if user with username exist.  If found then set session, if not redirect to login
            user = User.find_by(:username=>username)
            
            if user && user.authenticate(password)
                session[:username] = user.username
            end
        end

        def logout!
            session.clear
        end
    end


end
