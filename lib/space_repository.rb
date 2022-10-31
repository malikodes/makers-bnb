require_relative 'space'

class SpaceRepository

    def all
        sql = 'SELECT id, name, description, price, availability FROM spaces;'
        results = DatabaseConnection.exec_params(sql,[])

        spaces = []

        results.each do | record |
            space = Space.new
            space.id = record['id']
            space.name = record['name']
            space.description = record['description']
            space.price = record['price']
            space.availability = record['availability']

            spaces << space
        end

        return spaces

    end

    def find(id)
        sql = 'SELECT id, name, description, price, availability FROM spaces WHERE id = $1;'
        results = DatabaseConnection.exec_params(sql,[id])

        record = results[0]

        space = Space.new
        space.id = record['id']
        space.name = record['name']
        space.description = record['description']
        space.price = record['price']
        space.availability = record['availability']

        return space

    end

end