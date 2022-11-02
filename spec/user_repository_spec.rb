require 'user_repository'

def reset_user_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do
    reset_user_table
  end

  context "create new user" do
    it "returns all the users with the new user" do
      repo = UserRepository.new

      user = User.new
      user.username = 'sabrina_carpenter'
      user.email = 'sabrina_carpenter@email.com'
      user.password = 'emails'

      repo.create(user)

      user = repo.find_by_id(2)

      expect(user.username).to eq 'sabrina_carpenter'
      expect(user.email).to eq 'sabrina_carpenter@email.com'
    end
  end

  context "find by email" do
    it "returns the user" do
      repo = UserRepository.new

      user = repo.find_by_email('user_one@email.com')

      expect(user.id).to eq 1
      expect(user.username).to eq 'user_one'
      expect(user.name).to eq 'User 1'
    end
  end

  context "find by username" do
    it "returns the user" do
      repo = UserRepository.new

      user = repo.find_by_username('user_one')

      expect(user.id).to eq 1
      expect(user.email).to eq 'user_one@email.com'
    end
  end

  context "find by id" do
    it "returns the user" do
      repo = UserRepository.new

      user = repo.find_by_id('1')

      expect(user.username).to eq 'user_one'
      expect(user.email).to eq 'user_one@email.com'
    end
  end

  context "sign in" do
    it "signs in successfully" do
      repo = UserRepository.new

      user = User.new
      user.username = 'sabrina_carpenter'
      user.email = 'sabrina_carpenter@email.com'
      user.password = 'emails'

      repo.create(user)

      signed_in = repo.sign_in('sabrina_carpenter@email.com', 'emails')

      expect(signed_in).to eq true
    end

    it "fails to signs in" do
      repo = UserRepository.new

      user = User.new
      user.username = 'sabrina_carpenter'
      user.name = 'Sabrina Carpenter'
      user.email = 'sabrina_carpenter@email.com'
      user.password = 'emails'

      repo.create(user)

      signed_in = repo.sign_in('sabrina_carpenter@email.com', 'hi')

      expect(signed_in).to eq false
    end
  end
end
