require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'space_repository'
require 'space_repository_spec'



RSpec.describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    reset_spaces_table
  end

  context 'GET /' do
    it 'returns the home page with a login button' do
      response = get("/")

      expect(response.status).to eq 200
      expect(response.body).to include "<h1>Welcome to Makers BnB</h1>"
      expect(response.body).to include '<a href="/spaces">Log In</a>'
    end
  end

  context 'GET /spaces' do
    it 'returns a page with all spaces' do
      response = get('/spaces')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Book a Space</h1>')
    end
  end

  context 'GET /spaces/:id' do
    it 'returns an html with a space' do
        response = get('/spaces/1')
        expect(response.status).to eq 200
        expect(response.body).to include('<h1>Place 1</h1>')
    end
  end

  context 'POST /spaces' do
    it 'should add a new space' do
      response_post = post('/spaces',name: 'Place 4',
          description: 'This is place 4',
          price: 150.00,
          availability: '01/01/2022')

      response = get('/spaces')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/spaces/4">Place 4')

      response = get('/spaces/4')
      expect(response.body).to include('<h1>Place 4</h1>')
      expect(response.body).to include('£150')
      expect(response.body).to include('01/01/2022')
    end
  end

  context 'POST /bookings' do
    it 'should create a booking' do
      response = post('/bookings/2', username: 'User1', start_date: '2022-12-14', end_date: '2022-12-15')

      expect(response.status).to eq 302

      response = get('/bookings/2')

      expect(response.body).to include('<h1>Booking Confirmation</h1>')
      expect(response.body).to include('<p><strong>Username: </strong>User1</p>')
      expect(response.body).to include('<p><strong>Space: </strong><a href="/spaces/2">Place 2</a></p>')
      expect(response.body).to include('<p><strong>Start Date: </strong>14/12/2022</p>')
      expect(response.body).to include('<p><strong>End Date:</strong> 15/12/2022</p>')
    end
  end
end
