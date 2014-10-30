require 'rspec'
require 'spec_helper'
require 'user'

describe User do
  describe '#initialize' do
    it 'checks username' do
      user = User.new(username: 'test', password: 'test')
      expect(user.username).to eq('test')
    end
    it 'checks password' do
      user = User.new(username: 'test', password: 'test')
      expect(user.password).to eq('test')
    end
    it 'chscks user balance' do
      user = User.new(username: 'test', password: 'test')
      expect(user.balance).to eq(0)
    end
    it 'checks if cart is created' do
      user = User.new(username: 'test', password: 'test')
      expect(user.cart).to be_a Cart
    end
    it 'checks if gamelist is created' do
      user = User.new(username: 'test', password: 'test')
      expect(user.gamelist).to match_array([])
    end
    it 'checks if purchase list is created' do
      user = User.new(username: 'test', password: 'test')
      expect(user.purchases).to match_array([])
    end
    it 'checks if created user is not blocked' do
      user = User.new(username: 'test', password: 'test')
      expect(user.blocked).to be false
    end
  end
  describe 'adds item to cart' do
    it 'checks if balance has changed' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.add_to_cart(game) }.to change { user.cart.price }.by(10)
    end
    it 'checks if item is in a cart after adding it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect(user.cart.itemlist).to include(game)
    end
    it 'checks if error is raised if item is not a Game type'do
      user = User.new(username: 'test', password: 'test')
      expect { user.add_to_cart(1) }.to raise_error
    end
    it 'checks if error is raised if user tries to add the same item twice' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { 2.times { user.add_to_cart(game) } }.to raise_error
    end
    it 'checks if cart price is 0 after clearing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      user.clear_cart
      expect(user.cart.price).to eq(0)
    end
    it 'checks if cart item list is empty after clearing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      user.clear_cart
      expect(user.cart.itemlist).to match_array([])
    end
  end
  describe 'removes item from cart' do
    it 'raises error if item is not in a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.remove_from_cart(1) }.to raise_error
    end
    it 'checks if cart price changes after removing item from a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.remove_from_cart(game) }
             .to change { user.cart.price }.by(-10)
    end
    it ' checks if item is removed from the cart after removing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.remove_from_cart(game) }
              .to change { user.cart.itemlist }.to([])
    end
    it 'checks if error is raised after removing item that is not in a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.remove_from_cart(game) }.to raise_error
    end
  end
  describe 'change user balance' do
    it 'checks if user balance has changed' do
      user = User.new(username: 'test', password: 'test')
      user.balance = 10
      expect(user.balance).to eq(10)
    end
  end
  describe 'buys items in a cart' do
    it 'checks if error is raised after trying to buy an empty cart' do
      user = User.new(username: 'test', password: 'test')
      expect { user.buy }.to raise_error
    end
    it 'checks if error is raised after buying a cart with insuficent
        balance' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.buy }.to raise_error
    end
    it 'checks if user balance has changed after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      user.balance = 10
      expect { user.buy }.to change { user.balance }.by(-10)
    end
    it 'checks if purchased games are in a user gamelist after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      user.balance = 10
      user.buy
      expect(user.gamelist).to include(game)
    end
  end
  describe 'sorts games in gamelist' do
    it 'checks if games in gamelst are sorted by name' do
      user = User.new(username: 'test', password: 'test')
      user.gamelist.push(Game.new(name: 'b', genre: 'Genre test',
                         description: 'Game description test', price: 10))
      user.gamelist.push(Game.new(name: 'a', genre: 'Genre test',
                         description: 'Game description test', price: 10))
      expect { user.sort }.to change { user.gamelist }
    end
    it 'checks if error is raised after trying to sort an empty gamelist ' do
      user = User.new(username: 'test', password: 'test')
      expect { user.sort }.to raise_error
    end
  end
  describe 'purchase info' do
    it 'checks if purchase info is added after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.balance = 100
      user.add_to_cart(game)
      user.buy
      expect(user.purchases).to include([Time, 10, [game]])
    end
  end
  describe 'rates a game' do
    it 'checks if error is raised after rating something that is not a game' do
      user = User.new(username: 'test', password: 'test')
      expect { user.rate_game(game: 0, rating: 0) }.to raise_error
    end
    it 'checks if error was raised after rating a game with invalid data' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.rate_game(game: game, rating: 6) }.to raise_error
    end
    it 'checks if rating was added after user rated the game' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.rate_game(game: game, rating: 5) }
             .to change { game.ratings }
    end
  end
end
