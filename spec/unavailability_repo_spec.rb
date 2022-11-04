require 'unavailability_repo'

def reset_unavailable_table
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end
  
RSpec.describe UnavailabilityRepository do
    before(:each) do 
        reset_unavailable_table
    end

    it "returns a list of all spaces unavailable " do
        repo = UnavailabilityRepository.new
        spaces = repo.all
        expect(spaces.length).to eq 2
    end

    it "returns an array of unavailable spaces " do
        repo = UnavailabilityRepository.new
        spaces = repo.filter("12/12/2022", "13/12/2022")
        expect(spaces.length).to eq 1

    end


end
