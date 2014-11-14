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

RSpec::Matchers.define :include_a_clone_of do |game_clone|
  match do |games|
    games.any? do |game|
      game.class == game_clone.class &&
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
  before :each do
    User.clear
    Purchase.clear_sales
    Game.clear
  end
  it 'checks initialization' do
    expect { User.register('test', 'test') }
            .to change { User.users }.from([]).to([User])
  end
  describe 'adds item to cart' do
    it 'checks if balance has changed' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.add_to_cart(game.id) }.to change { user.cart.price }.by(10)
    end
    it 'checks if cart price is equal to sum of all item prices' do
      user = User.new(username: 'test', password: 'test')
      game1 = Game.new(name: 'a', genre: 'b', description: 'c', price: 10)
      game2 = Game.new(name: 'a', genre: 'b', description: 'c', price: 20)
      user.add_to_cart(game1.id, 5)
      user.add_to_cart(game2.id, 2)
      expect(user.cart.itemlist).to be_a_sum_of_prices(user.cart.price)
    end
    it 'checks if item is in a cart after adding it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      expect(user.cart.itemlist).to include(game)
    end
    it 'checks if two items were added' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { user.add_to_cart(game.id, 2) }
              .to change { user.cart.itemlist[game] }.to(2)
    end
    it 'checks if two items were added if item was already in a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id, 1)
      expect { user.add_to_cart(game.id, 2) }
              .to change { user.cart.itemlist[game] }.to(3)
    end
    it 'checks if cart price is 0 after clearing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      user.clear_cart
      expect(user.cart.price).to eq(0)
    end
    it 'checks if cart item list is empty after clearing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      user.clear_cart
      expect(user.cart.itemlist).to match_array([])
    end
  end
  describe 'removes item from cart' do
    it 'checks if cart price changes after removing item from a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id, 2)
      expect { user.remove_from_cart(game.id) }
             .to change { user.cart.price }.by(-20)
    end
    it ' checks if item is removed from the cart after removing it' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      expect { user.remove_from_cart(game.id) }
              .to change { user.cart.itemlist }.to([])
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
    it 'checks if user balance has changed after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      user.balance = 10
      expect { user.buy }.to change { user.balance }.by(-10)
    end
    it 'checks if purchased games are in a user gamelist after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.add_to_cart(game.id)
      user.balance = 10
      user.buy
      expect(user.gamelist).to include_a_clone_of(game)
    end
  end
  describe 'sorts games in gamelist' do
    it 'checks if games in gamelst are sorted by name' do
      user = User.new(username: 'test', password: 'test')
      game1 = Game.new(name: 'b', genre: 'Genre test',
                       description: 'Game description test', price: 10)
      game2 = Game.new(name: 'a', genre: 'Genre test',
                       description: 'Game description test', price: 10)
      user.gamelist.push(game1)
      user.gamelist.push(game2)
      expect { user.sort }.to change { user.gamelist }
                          .from([game1, game2]).to([game2, game1])
    end
  end
  describe 'purchase info' do
    it 'checks if purchase info is added after buying a cart' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      user.balance = 100
      user.add_to_cart(game.id)
      user.buy
      expect(user.purchases).to include(Purchase)
    end
  end
  describe 'sends a message' do
    it 'checks if highest comment id is eq or less to comment nummber' do
      user = User.new(username: 'test', password: 'test')
      user.send_message(user.id, 'topic', 'text')
      user.send_message(user.id, 'topic', 'text')
      expect(user.messages).to be_eq_to_user_message_id(user.message_id)
    end
    it 'checks if message was sent' do
      sender = User.new(username: 'test', password: 'test')
      receiver = User.new(username: 'test', password: 'test')
      sender.send_message(receiver.id, 'topic', 'text')
      expect(User.get_by_id(receiver.id).messages).to include(Message)
    end
  end
  describe 'login' do
    it 'checks login' do
      user = User.register('test', 'test')
      expect { User.login('test', 'test') }.to change { user.logged_in }
              .from(false).to(true)
    end
  end
  describe 'delete' do
    it 'checks deletion' do
      user = User.register('test', 'test')
      user.delete
      expect(User.users).not_to include(user)
    end
  end
  describe 'admin' do
    it 'grants admin' do
      user = User.register('test', 'test')
      expect { user.make_admin }.to change { user.admin }.from(false).to(true)
    end
  end
  describe 'block' do
    it 'blocks the user' do
      user = User.register('test', 'test')
      expect { user.block }.to change { user.blocked }.from(false).to(true)
    end
    it 'unblocks the user' do
      user = User.register('test', 'test')
      user.block
      expect { user.unblock }.to change { user.blocked }.from(true).to(false)
    end
  end
  describe 'edits' do
    it 'checks if editing user balance works' do
      user = User.register('test', 'test')
      expect { user.edit_balance(500) }. to change { user.balance }
             .from(0).to(500)
    end
  end
  describe 'info' do
    it 'checks ir user info was returned' do
      user = User.register('test', 'test')
      info = user.info
      expect(info).to match_array([1, 'test', 0, false, false])
    end
  end
  describe 'saves/loads' do
    it 'from/to file' do
      User.register('username', 'password')
      users = User.all_users.map(&:username)
      User.save_to_file('test.yaml')
      User.clear
      User.load_from_file('test.yaml')
      usrs = User.users.map(&:username)
      expect(usrs).to eql(users)
    end
  end
end
