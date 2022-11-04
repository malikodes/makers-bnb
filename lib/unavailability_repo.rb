require_relative 'unavailability'

class UnavailabilityRepository

    def all
        sql = 'SELECT * FROM unavailable_dates;'
        result_set = DatabaseConnection.exec_params(sql, [])

        unavail_spaces = []

        result_set.each do | record |
            date_unavail = UnavailableDate.new
            date_unavail.id = record['id']
            date_unavail.unavailable_date = record['unavailable_date']
            date_unavail.space_id = record['space_id']
    
            unavail_spaces << date_unavail
        end
        return unavail_spaces
    end

 
    def filter(start_date, end_date)
        start = Date.parse(start_date)
        last = Date.parse(end_date)

        spaces = []
        
        all.each do |date|
            if !(start..last).to_a.include?(date)
                spaces << date.space_id
            end
        end

        return spaces.uniq
    end
end