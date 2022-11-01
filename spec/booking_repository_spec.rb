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
        expect(booking.username).to eq "User1"
        expect(booking.start_date).to eq "2022-12-12"
    end

    it "Creates a new booking" do
        repo = BookingRepository.new
        booking = Booking.new
        booking.username = "user2"
        booking.start_date = "2022-12-14"
        booking.end_date = "2022-12-15"
        booking.space_id = 2

        booking = repo.create(booking)
        new_booking = repo.find(2)
        expect(new_booking.username).to eq "user2"
        expect(new_booking.start_date).to eq "2022-12-14"
    end




end


