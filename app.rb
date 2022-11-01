require_relative 'lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/space_repository'

DatabaseConnection.connect


class Application < Sinatra::Base
    # This allows the app code to refresh
    # without having to restart the server.
    configure :development do
      register Sinatra::Reloader
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
    end

    get '/spaces/:id' do
      repo = SpaceRepository.new
      @space = repo.find(params[:id])

      return erb(:space)      
    end

    def invalid_request_parameters?
      return (params[:name] == nil || params[:description] == nil || params[:price] == nil || params[:availability] == nil )
   end

 

  end