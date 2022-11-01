require_relative 'booking'

class BookingRepository

    
    def find(id)
        sql = 'SELECT * FROM bookings WHERE id = $1;'
        results = DatabaseConnection.exec_params(sql,[id])

        record = results[0]

        booking = Booking.new
        booking.id = record['id']
        booking.username = record['username']
        booking.start_date = record['start_date']
        booking.end_date = record['end_date']
        booking.space_id = record['space_id']

        return booking

    end


    def create(booking)
        sql = 'INSERT INTO bookings (username, start_date, end_date, space_id) VALUES ($1, $2, $3, $4) ;'
        sql_params = [booking.username, booking.start_date, booking.end_date, booking.space_id]
        results = DatabaseConnection.exec_params(sql,sql_params)

        
        

    end
end