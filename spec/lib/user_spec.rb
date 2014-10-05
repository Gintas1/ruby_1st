require 'rspec'
require 'spec_helper'
require 'user'

describe User do
  describe '#initialize' do
    it 'sets new user' do
      user = User.new(:username =>'test', :password =>'test')
	  expect(user.username).to eq('test')
	  expect(user.password).to eq('test')
	  expect(user.balance).to eq(0)
	  expect(user.cart).to be_a Cart
	  expect(user.gamelist).to match_array([])
	  expect(user.purchases).to match_array([])
	end
  end
  describe 'cart' do
    it 'adds item to cart' do
	  user = User.new(:username =>'test', :password =>'test')
	  game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)	  
	  expect{ user.add_to_cart(game) }.to change{user.cart.price}.by(10)
	  expect(user.cart.itemlist).to include(game)
	  expect{ user.add_to_cart(1) }.to raise_error
	  expect{ user.add_to_cart(game) }.to raise_error
	end
    it 'clears the cart' do
      user = User.new(:username =>'test', :password =>'test')
      game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)
	  user.add_to_cart(game)
	  user.clear_cart
	  expect(user.cart.price).to eq(0)
	  expect(user.cart.itemlist).to match_array([])
	end
	it 'removes item from cart' do
	  user = User.new(:username =>'test', :password =>'test')
      game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)
	  user.add_to_cart(game)
	  expect{ user.remove_from_cart(1) }.to raise_error
	  expect{ user.remove_from_cart(game) }.to change{user.cart.price}.by(-10)
	  expect(user.cart.itemlist).to match_array([])
	  expect{ user.remove_from_cart(game) }.to raise_error
	end
  end
  describe 'buy' do
    it 'changes user balance' do
	  user = User.new(:username =>'test', :password =>'test')
	  user.balance = 10
	  expect(user.balance).to eq(10)
	end
	it 'buys items in a cart' do
	  user = User.new(:username =>'test', :password =>'test')
	  game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)
	  expect{user.buy}.to raise_error
	  user.add_to_cart(game)
	  expect{user.buy}.to raise_error
	  user.balance = 10
	  expect{user.buy}.to change{user.balance}.by(-10)
	  expect(user.gamelist).to include(game)
	  puts user.purchases
	end
  end
end