require 'rspec'
require 'spec_helper'
require 'admin'

describe Admin do
  describe '#initialize' do
    it 'checks username' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.username).to eq('test')
    end
    it 'checks password' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.password).to eq('test')
    end
    it 'chscks user balance' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.balance).to eq(0)
    end
    it 'checks if cart is created' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.cart).to be_a Cart
    end
    it 'checks if gamelist is created' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.gamelist).to match_array([])
    end
    it 'checks if purchase list is created' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.purchases).to match_array([])
    end
    it 'checks if created user is not blocked' do
      admin = Admin.new(username: 'test', password: 'test')
      expect(admin.blocked).to be false
    end
    it 'checks if created user is not blocked' do
      admin = Admin.new(username: 'test', password: 'test', admin_granted: 'test')
      expect(admin.admin_granted).to eq('test')
    end
  end
  describe 'adds' do
    it 'game' do
      admin = Admin.new(username: 'test', password: 'test', admin_granted: 'test')
      game = admin.add_game(name: 'Game name test', genre: 'Genre test',
                            description: 'Game description test', price: 10)
      expect(game).to be_a(Game)
    end
    it 'new admin' do
      admin = Admin.new(username: 'test', password: 'test', admin_granted: 'test')
      new_admin = admin.add_admin(username: 'test', password: 'test', admin_granted: admin)
      expect(new_admin).to be_a(Admin)
    end
  end
  describe 'edits' do
    it 'game price' do
      admin = Admin.new(username: 'test', password: 'test', admin_granted: 'test')
      game = admin.add_game(name: 'Game name test', genre: 'Genre test',
                            description: 'Game description test', price: 10)
      admin.edit_game_price(game, 5)
      expect(game.price).to eq(5)
    end
    it 'game description' do
      admin = Admin.new(username: 'test', password: 'test', admin_granted: 'test')
      game = admin.add_game(name: 'Game name test', genre: 'Genre test',
                            description: 'Game description test', price: 10)
      expect { admin.edit_game_description(game, 'test') }
	          .to change { game.description }.from('Game description test').to('test')	
    end
  end
end