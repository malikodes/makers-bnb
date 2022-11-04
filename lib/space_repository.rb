require_relative 'space'

class SpaceRepository
    def all
        sql = 'SELECT id, name, description, price, user_id FROM spaces;'
        results = DatabaseConnection.exec_params(sql,[])

        spaces = []

        results.each do | record |
            space = Space.new
            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']
            space.user_id = record['user_id']

            spaces << space
        end
        return spaces
    end

    def find(id)
        sql = 'SELECT id, name, description, price, user_id FROM spaces WHERE id = $1;'
        results = DatabaseConnection.exec_params(sql,[id])

        record = results[0]

        space = Space.new
        space.id = record['id']
        space.name = record['name']
        space.description = record['description']
        space.price = record['price']
        space.user_id = record['user_id']

        return space
    end

    def create(space)
        sql = 'INSERT INTO spaces (name, description, price, user_id) VALUES ($1, $2, $3, $4);'
        result_set = DatabaseConnection.exec_params(sql, [space.name, space.description, space.price, space.user_id])
    end



    def find_all(spaces)

        all_spaces = all.map { |space| space.id}

        available_spaces = []

        space_ids = all_spaces.reject {|space| spaces.include?(space) }

        space_ids.each do |space_id|
            sql = 'SELECT id, name, description, price FROM spaces WHERE id = $1;'
            results = DatabaseConnection.exec_params(sql,[space_id])

            record = results[0]

            space = Space.new
            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']

            available_spaces << space
        end

        return available_spaces.uniq
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
