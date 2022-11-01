require 'space_repository'

def reset_spaces_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  
RSpec.describe SpaceRepository do
    before(:each) do 
        reset_spaces_table
    end

    it "returns a list of all spaces" do
        repo = SpaceRepository.new
        spaces = repo.all
        expect(spaces.length).to eq 3
        expect(spaces[0].id).to eq "1"
        expect(spaces[0].name).to eq "Place 1"
    end

    it "finds the space with id of 1" do
        repo = SpaceRepository.new
        space = repo.find(2)

        expect(space.id).to eq "2"
        expect(space.name).to eq "Place 2"
        expect(space.price).to eq "128"
    end

    it 'creates an album' do
        repo = SpaceRepository.new
    
        space = Space.new
        space.name = 'Place 4'
        space.description = 'This is place 4'
        space.price = '150.50'
        space.availability = '01/01/2020'
        repo.create(space)
    
        spaces = repo.all
    
        expect(spaces.length).to eq(4)
        expect(spaces.last.name).to eq('Place 4')
        expect(spaces.last.description).to eq('This is place 4')
        expect(spaces.last.price).to eq('150.5')
        expect(spaces.last.availability).to eq('01/01/2020')
      end


end


