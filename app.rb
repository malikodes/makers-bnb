require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/space_repository'
require_relative 'lib/booking_repository'
require_relative 'lib/user_repository'

DatabaseConnection.connect


class Application < Sinatra::Base
    # This allows the app code to refresh
    # without having to restart the server.
    enable :sessions

    configure :development do
      register Sinatra::Reloader
    end


    get '/' do
      if session[:user_id].nil?
        erb(:home)
      else
        erb(:login_success)
      end
    end

    post '/login' do
      email = params[:email]
      password = params[:password]
      repo = UserRepository.new
      user = repo.find_by_email(email)
      if repo.sign_in(email, password)
        session[:user_id] = user.id
        erb(:login_success)
      else
        erb(:login_error)
      end
    end

    post '/logout' do
      session[:user_id] = nil
      redirect('/')
    end

    get '/sign_up' do
      if session[:user_id].nil?
        erb(:sign_up)
      else
        redirect('/spaces')
      end
    end

    post '/users' do
      repo = UserRepository.new
      if invalid_user_request_parameters?
        erb(:sign_up_error_empty)
      elsif !repo.find_by_email(params[:email]).nil?
        erb(:sign_up_error_email)
      elsif !repo.find_by_username(params[:username]).nil?
        erb(:sign_up_error_username)
      else
        user = User.new
        user.username = params[:username] if params[:username] !~ /<\w+>/
        user.name = params[:name] if params[:name] !~ /<\w+>/
        user.email = params[:email] if params[:email] !~ /<\w+>/
        user.password = params[:password] if params[:password] !~ /<\w+>/
        repo.create(user)
        erb(:sign_up_successful)
      end
    end

    get '/spaces' do
      repo = SpaceRepository.new
      @spaces = repo.all

      return erb(:all_spaces)
    end

    get '/spaces/new' do
      if session[:user_id].nil?
        redirect('/')
      else
        return erb(:new_space)
      end
    end

    post '/spaces' do
      if invalid_request_parameters?
        status 400
        return ''
      end

      space = Space.new
      space.name = params[:name] if params[:name] !~ /<\w+>/
      space.description = params[:description] if params[:description] !~ /<\w+>/
      space.price = params[:price] if params[:price] !~ /<\w+>/
      space.availability = params[:availability] if params[:availability] !~ /<\w+>/

      space_repository = SpaceRepository.new
      space_repository.create(space)

      redirect('/spaces')
    end

    get '/spaces/:id' do
      repo = SpaceRepository.new
      @space = repo.find(params[:id])
      @user_id = session[:user_id]

      return erb(:space)
    end

    get '/bookings/:id' do
      booking_repo = BookingRepository.new
      space_repo = SpaceRepository.new
      user_repo = UserRepository.new
      @booking = booking_repo.find(params[:id])
      @space = space_repo.find(@booking.space_id)
      @user = user_repo.find_by_id(session[:user_id])
      return erb(:booking_confirmation)
    end

    post '/bookings/:space_id' do
      if session[:user_id].nil?
        redirect("/")
      else
        if invalid_booking_request_parameters?
          status 400
          return ''
        end
        booking = Booking.new
        booking.user_id = session[:user_id]
        booking.start_date = params[:start_date] if params[:start_date] !~ /<\w+>/
        booking.end_date = params[:end_date] if params[:end_date] !~ /<\w+>/
        booking.space_id = params[:space_id]
        repo = BookingRepository.new
        id = repo.create(booking)
        redirect("/bookings/#{id}")
      end
    end

    get '/requests' do
      if session[:user_id].nil?
        redirect("/")
      else
        booking_repo = BookingRepository.new
        @space_repo = SpaceRepository.new
        user_repo = UserRepository.new
        @user = user_repo.find_by_id(session[:user_id])
        @bookings = booking_repo.all_by_user(session[:user_id])
        return erb(:requests)
      end
    end

    private

    def invalid_request_parameters?
      return (params[:name] == nil || params[:description] == nil || params[:price] == nil || params[:availability] == nil )
    end

    def invalid_booking_request_parameters?
      return (params[:start_date] == nil || params[:end_date] == nil || params[:space_id] == nil || session[:user_id] == nil )
    end

    def invalid_user_request_parameters?
      return (params[:username] == "" || params[:name] == "" || params[:email] == "" || params[:password] == "")
    end

    def invalid_post_request_parameters?
      params[:content].nil?
    end
  end
