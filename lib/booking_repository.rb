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
      results = DatabaseConnection.exec_params(sql, sql_params)
      p find_id(booking.username, booking.start_date, booking.end_date, booking.space_id)
      return find_id(booking.username, booking.start_date, booking.end_date, booking.space_id)
    end

  private

  def find_id(username, start_date, end_date, space_id)
    sql = 'SELECT * FROM bookings WHERE username = $1 AND start_date = $2 AND end_date = $3 AND space_id = $4;'
    results = DatabaseConnection.exec_params(sql,[username, start_date, end_date, space_id])

    record = results[0]

    return record['id']
  end
end
