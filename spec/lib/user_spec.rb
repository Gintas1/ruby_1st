require 'rspec'
require 'spec_helper'
require 'user'

RSpec::Matchers.define :be_a_sum_of_prices do |sum|
  match do |elements|
    price = 0
    elements.each { |item, amount| price += item.price * amount }
    price == sum
  end
end

RSpec::Matchers.define :be_eq_to_user_message_id do |comment_num|
  match do |messages|
    max = messages.max { |a, b| a.id <=> b.id }
    max.id <= comment_num
  end
end

RSpec::Matchers.define :be_include_a_clone_of do |game_clone|
  match do |games|
    games.any? do |game|
      game.name == game_clone.name &&
      game.description == game_clone.description &&
      game.genre == game_clone.genre &&
      game.price == game_clone.price &&
      game.comment_count == game_clone.comment_count &&
      game.comments == game_clone.comments &&
      game.ratings == game_clone.ratings
    end
  end
end

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
    it 'checks if created user message array' do
      user = User.new(username: 'test', password: 'test')
      expect(user.messages).to match_array([])
    end
    it 'checks if created user has message id' do
      user = User.new(username: 'test', password: 'test')
      expect(user.message_id).to eq(0)
    end
  end
  describe 'adds item to cart' do
    it 'checks if balance has changed' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.add_to_cart(game) }.to change { user.cart.price }.by(10)
    end
    it 'checks if cart price is equal to sum of all item prices' do
      user = User.new(username: 'test', password: 'test')
      game1 = Game.new(name: 'a', genre: 'b', description: 'c', price: 10)
      game2 = Game.new(name: 'a', genre: 'b', description: 'c', price: 20)
      user.add_to_cart(game1, 5)
      user.add_to_cart(game2, 2)
      expect(user.cart.itemlist).to be_a_sum_of_prices(user.cart.price)
    end
    it 'checks if item is in a cart after adding it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect(user.cart.itemlist).to include(game)
    end
    it 'checks if two items were added' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.add_to_cart(game, 2) }
              .to change { user.cart.itemlist[game] }.to(2)
    end
    it 'checks if two items were added if item was already in a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game, 1)
      expect { user.add_to_cart(game, 2) }
              .to change { user.cart.itemlist[game] }.to(3)
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
    it 'outputs message if item is not in a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.remove_from_cart(1) }.to output.to_stdout
    end
    it 'checks if cart price changes after removing item from a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game, 2)
      expect { user.remove_from_cart(game) }
             .to change { user.cart.price }.by(-20)
    end
    it ' checks if item is removed from the cart after removing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.remove_from_cart(game) }
              .to change { user.cart.itemlist }.to([])
    end
    it 'checks if message was output after removing non existing item' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.remove_from_cart(game) }.to output.to_stdout
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
    it 'checks if message was output after trying to buy an empty cart' do
      user = User.new(username: 'test', password: 'test')
      expect { user.buy }.to output.to_stdout
    end
    it 'checks if message was output after buying a cart with insuficent
        balance' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game)
      expect { user.buy }.to output.to_stdout
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
      expect(user.gamelist).to be_include_a_clone_of(game)
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
    it 'checks if message was output after trying to sort an empty gamelist ' do
      user = User.new(username: 'test', password: 'test')
      expect { user.sort }.to output.to_stdout
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
      expect(user.purchases).to include(Purchase)
    end
  end
  describe 'rates a game' do
    it 'checks if message was output after rating not a game' do
      user = User.new(username: 'test', password: 'test')
      expect { user.rate_game(game: 0, rating: 0) }.to output.to_stdout
    end
    it 'checks if message was output after rating a game with invalid data' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.rate_game(game: game, rating: 6) }.to output.to_stdout
    end
    it 'checks if rating was added after user rated the game' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.rate_game(game: game, rating: 5) }
             .to change { game.ratings }
    end
  end
  describe 'comment game' do
    it 'checks if user commented a game' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.comment_game(game: game, text: 'test text') }
             .to change { game.comments }.from([])
    end
  end
  describe 'sends a message' do
    it 'checks if highest comment id is eq or less to comment nummber' do
      user = User.new(username: 'test', password: 'test')
      user.send_message(topic: 'topic', text: 'text', receiver: user)
      user.send_message(topic: 'topic', text: 'text', receiver: user)
      expect(user.messages).to be_eq_to_user_message_id(user.message_id)
    end
    it 'checks if message was sent' do
      sender = User.new(username: 'test', password: 'test')
      receiver = User.new(username: 'test', password: 'test')
      sender.send_message(topic: 'topic', text: 'text', receiver: receiver)
      expect(receiver.messages).to include(Message)
    end
  end
  describe 'validation' do
    it 'checks username validation' do
      user = User.new(username: 'test', password: 'test')
      valid = user.check_username('test')
      expect(valid).to be true
    end
    it 'checks username validation' do
      user = User.new(username: 'test', password: 'test')
      valid = user.check_data('test', 'test')
      expect(valid).to be true
    end
  end
end
