require 'booking_repository'

def reset_spaces_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

RSpec.describe BookingRepository do
  before(:each) do
    reset_spaces_table
  end

  it "finding the booking with id1" do
    repo = BookingRepository.new
    booking = repo.find(1)

    expect(booking.id).to eq "1"
    expect(booking.user_id).to eq "1"
    expect(booking.start_date).to eq "2022-12-12"
  end

  it "creates a new booking" do
    repo = BookingRepository.new
    booking = Booking.new
    booking.user_id = 1
    booking.start_date = "2022-12-14"
    booking.end_date = "2022-12-15"
    booking.space_id = 2
    booking.confirmed = nil

    booking_test = repo.create(booking)
    expect(booking_test).to eq "2"
    new_booking = repo.find(2)
    expect(new_booking.user_id).to eq "1"
    expect(new_booking.start_date).to eq "2022-12-14"
  end

  it "returns a list of bookings with user_id = 1" do
    repo = BookingRepository.new
    bookings = repo.all_by_user(1)
    expect(bookings.length).to eq 1
    expect(bookings[0].start_date).to eq '2022-12-12'
    expect(bookings[0].end_date).to eq '2022-12-13'
    expect(bookings[0].space_id).to eq '1'
  end
end
