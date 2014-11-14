require 'rspec'
require 'spec_helper'
require 'purchase'

describe Purchase do
  before :each do
    User.clear
    Purchase.clear_sales
    Game.clear
  end
  it 'checks initialization' do
    user = User.new(username: 'test', password: 'test')
    items = Hash.new
    items[Game.new(name: 'name', description: 'd', genre: 'gen', price: 10)] = 1
    price = 10
    expect { Purchase.new(user: user, items: items, price: price) }
           .to change { Purchase.sales }.from([]).to([Purchase])
  end
  it 'checks if sale list works' do
    user = User.register('test', 'test')
    game = Game.new_game('name', 'desc', 'genre', 10)
    user.add_to_cart(game.id)
    user.buy
    sales = Purchase.sale_info
    expect(sales).to include(Purchase)
  end
  describe 'saves/loads' do
    it 'from/to file' do
      user = User.register('username', 'password')
      Purchase.new(buyer: user, price: 10, items: [])
      purchases = Purchase.sale_info.map(&:id)
      Purchase.save_to_file('test.yaml')
      Purchase.clear_sales
      Purchase.load_from_file('test.yaml')
      purch = Purchase.sales.map(&:id)
      expect(purchases).to eq(purch)
    end
  end
end
