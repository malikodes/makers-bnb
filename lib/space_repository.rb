require_relative 'space'

class SpaceRepository
    def all
        sql = 'SELECT id, name, description, price, availability, user_id FROM spaces;'
        results = DatabaseConnection.exec_params(sql,[])

        spaces = []

        results.each do | record |
            space = Space.new
            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']
            space.availability = record['availability']
            space.user_id = record['user_id']

            spaces << space
        end
        return spaces
    end

    def find(id)
        sql = 'SELECT id, name, description, price, availability, user_id FROM spaces WHERE id = $1;'
        results = DatabaseConnection.exec_params(sql,[id])

        record = results[0]

        space = Space.new
        space.id = record['id']
        space.name = record['name']
        space.description = record['description']
        space.price = record['price']
        space.availability = record['availability']
        space.user_id = record['user_id']

        return space
    end

    def create(space)
        sql = 'INSERT INTO spaces (name, description, price, availability, user_id) VALUES ($1, $2, $3, $4, $5);'
        result_set = DatabaseConnection.exec_params(sql, [space.name, space.description, space.price, space.availability, space.user_id])
    end

    def all_ids_by_user(user_id)
      sql = 'SELECT * FROM spaces WHERE user_id = $1;'
      results = DatabaseConnection.exec_params(sql, [user_id])

      spaces = []

      results.each do |record|
        spaces << record['id']
      end

      return spaces
    end
end
