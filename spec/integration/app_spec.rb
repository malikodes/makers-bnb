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

    context 'GET /spaces' do
        it 'returns a page with all spaces' do
        response = get('/spaces')
        expect(response.status).to eq 200
        expect(response.body).to include('<h1>All Spaces</h1>')
        end

    end

    context 'get /spaces/new' do
        it 'should add a new space' do

            response_post = post('/spaces/new',name: 'Place 4',
                description: 'This is place 4',
                price: 150.00,
                availability: '01/01/2022')
     
            response = get('/spaces')
    
            expect(response.status).to eq(200)
            expect(response.body).to include('<a href="/spaces/4">Place 4')
        end

        it 'should return a html page with this new space' do
            response = get('/spaces/4')
            expect(response.body).to include('<h1>This is place 4</h1>')
            expect(response.body).to include('<p>This is place 4')
            expect(response.body).to include('£150')
            expect(response.body).to include('<p>Availability: 01/01/2022</p>')
        end
    end
end
      
    
