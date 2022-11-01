require_relative 'lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/space_repository'
require_relative 'lib/booking_repository'

DatabaseConnection.connect


class Application < Sinatra::Base
    # This allows the app code to refresh
    # without having to restart the server.
    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      erb(:home)
    end

    get '/spaces' do
      repo = SpaceRepository.new
      @spaces = repo.all

      return erb(:all_spaces)
    end

    get '/spaces/new' do
      return erb(:new_space)
    end

    post '/spaces' do
      if invalid_request_parameters?
        status 400
        return ''
      end

      space = Space.new
      space.name = params[:name]
      space.description = params[:description]
      space.price = params[:price]
      space.availability = params[:availability]

      space_repository = SpaceRepository.new
      space_repository.create(space)

      redirect('/spaces')
    end

    get '/spaces/:id' do
      repo = SpaceRepository.new
      @space = repo.find(params[:id])

      return erb(:space)
    end

    get '/bookings/:id' do
      booking_repo = BookingRepository.new
      space_repo = SpaceRepository.new
      @booking = booking_repo.find(params[:id])
      @space = space_repo.find(@booking.space_id)
      return erb(:requests)
    end

    post '/bookings/:space_id' do
      if invalid_booking_request_parameters?
        status 400
        return ''
      end
      booking = Booking.new
      booking.username = params[:username]
      booking.start_date = params[:start_date]
      booking.end_date = params[:end_date]
      booking.space_id = params[:space_id]
      repo = BookingRepository.new
      id = repo.create(booking)
      redirect("/bookings/#{id}")
    end

    def invalid_request_parameters?
      return (params[:name] == nil || params[:description] == nil || params[:price] == nil || params[:availability] == nil )
    end

    def invalid_booking_request_parameters?
      return (params[:username] == nil || params[:start_date] == nil || params[:end_date] == nil || params[:space_id] == nil )
    end
  end
