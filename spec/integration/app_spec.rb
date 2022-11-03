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
      expect(response.body).to include "Welcome to MakersBnB"
      expect(response.body).to include 'Log In'
    end
  end

  it "redirects to successful login page if logged in" do
    post("/users", username: 'olivia_rodrigo', name: 'Olivia Rodrigo', email: 'olivia_rodrigo@email.com', password: "butterflies")
    post("/login", email: 'olivia_rodrigo@email.com', password: "butterflies")

    response = get("/")

    expect(response.status).to eq 200
    expect(response.body).to include '<p>You have successfully logged in!</p>'
  end

  context "POST /login" do
    it "returns 200 OK and logs in" do
      post("/users", username: 'olivia_rodrigo', name: 'Olivia Rodrigo', email: 'olivia_rodrigo@email.com', password: "butterflies")
      response = post("/login", email: 'olivia_rodrigo@email.com', password: "butterflies")

      expect(response.body).to include "<p>You have successfully logged in!</p>"
    end

    it "returns fails" do
      response = post("/login", email: 'olivia_rodrigo@email.com', password: "butterfly")

      expect(response.body).to include '<p>Log in failed please <a href="/">try again</a></p>'
    end
  end

  context "POST /logout" do
    it "logs the user out of the session returns 200 OK" do
      response = post("/logout")

      expect(response.status).to eq 302

      response = get("/")

      expect(response.body).to include '<h1 class="form-header">Log In</h1>'
      expect(response.body).to include '<form action="/login" method="POST">'
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
      post("/users", username: 'olivia_rodrigo', name: 'Olivia Rodrigo', email: 'olivia_rodrigo@email.com', password: "butterflies")
      post("/login", email: 'olivia_rodrigo@email.com', password: "butterflies")
      response = post('/bookings/2', user_id: 2, start_date: '2022-12-14', end_date: '2022-12-15', space_id: 2)

      expect(response.status).to eq 302

      response = get('/bookings/2')

      expect(response.body).to include('<h1>Booking Confirmation</h1>')
      expect(response.body).to include('<p><strong>Username: </strong>Olivia_rodrigo</p>')
      expect(response.body).to include('<p><strong>Space: </strong><a href="/spaces/2">Place 2</a></p>')
      expect(response.body).to include('<p><strong>Start Date: </strong>14/12/2022</p>')
      expect(response.body).to include('<p><strong>End Date:</strong> 15/12/2022</p>')
    end
  end

  context "GET sign_up when not logged in" do
    it "returns 200 OK and sign up form" do
      response = get("sign_up")

      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/users" method="POST">'
      expect(response.body).to include '<input type="text" name="username">'
      expect(response.body).to include '<input type="text" name="name">'
      expect(response.body).to include '<input type="email" name="email">'
      expect(response.body).to include '<input type="text" name="password">'
    end
  end

  context "POST /users" do
    it "returns 200 OK and sign up success message" do
      response = post("/users", username: 'olivia_rodrigo', name: 'Olivia Rodrigo', email: 'olivia_rodrigo@email.com', password: "butterflies")

      expect(response.status).to eq 200
      expect(response.body).to include "<p>You have successfully signed up!</p>"
    end

    it "redirects to an error page when email has already been used" do
      response = post("/users", username: 'harry_styles', name: 'Harry Styles', email: 'user_one@email.com', password: "cherry")

      expect(response.status).to eq 200
      expect(response.body).to include "<p>Sign up failed, this email address has already been signed up.</p>"
      expect(response.body).to include '<p>Please <a href="/sign_up">try again</a> with a different email address.</p>'
      expect(response.body).to include '<p>Or <a href="/login">log in</a>.</p>'
    end

    it "redirects to an error page when username has already been used" do
      response = post("/users", username: 'user_one', name: 'Harry Styles', email: 'harry_styles@email.com', password: "cherry")

      expect(response.status).to eq 200
      expect(response.body).to include "<p>Sign up failed, this username has already been used.</p>"
      expect(response.body).to include '<p>Please <a href="/sign_up">try again</a> with a different username.</p>'
      expect(response.body).to include '<p>Or <a href="/login">log in</a>.</p>'
    end

    it "redirects to an error page when fields have been left empty" do
      response = post("/users")

      expect(response.status).to eq 200
      expect(response.body).to include "<p>Sign up failed, you cannot leave any fields empty.</p>"
      expect(response.body).to include '<p>Please <a href="/sign_up">try again</a>.</p>'
    end
  end
end
