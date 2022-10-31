require_relative 'lib/database_connection'
require 'sinatra/base'
require 'sinatra/reloader'

DatabaseConnection.connect


class Application < Sinatra::Base
    # This allows the app code to refresh
    # without having to restart the server.
    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      repo = SpaceRepository.new
      @space = repo.all
      
      return erb(:all_spaces)

    end



  end