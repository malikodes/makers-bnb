require_relative 'booking'

class BookingRepository
    def find(id)
        sql = 'SELECT * FROM bookings WHERE id = $1;'
        results = DatabaseConnection.exec_params(sql,[id])

        record = results[0]

        booking = Booking.new
        booking.id = record['id']
        booking.user_id = record['user_id']
        booking.start_date = record['start_date']
        booking.end_date = record['end_date']
        booking.space_id = record['space_id']
        booking.confirmed = record['confirmed']

        return booking
    end

    def create(booking)
      sql = 'INSERT INTO bookings (start_date, end_date, confirmed, space_id, user_id) VALUES ($1, $2, $3, $4, $5);'
      sql_params = [booking.start_date, booking.end_date, booking.confirmed, booking.space_id, booking.user_id]
      results = DatabaseConnection.exec_params(sql, sql_params)
      return find_id(booking.start_date, booking.end_date, booking.space_id, booking.user_id)
    end

    def all_by_user(user_id)
      sql = 'SELECT * FROM bookings WHERE user_id = $1;'
      results = DatabaseConnection.exec_params(sql, [user_id])

      bookings = []

      results.each do |record|
        booking = Booking.new
        booking.id = record['id']
        booking.start_date = record['start_date']
        booking.end_date = record['end_date']
        booking.confirmed = record['confirmed']
        booking.confirmed = record['confirmed'] if !record['confirmed'].nil?
        booking.space_id = record['space_id']
        booking.user_id = record['user_id']

        bookings << booking
      end

      return bookings
    end

  private

  def find_id(start_date, end_date, space_id, user_id)
    sql = 'SELECT * FROM bookings WHERE start_date = $1 AND end_date = $2 AND space_id = $3 AND user_id = $4;'
    results = DatabaseConnection.exec_params(sql,[start_date, end_date, space_id, user_id])

    record = results[0]

    return record['id']
  end
end
