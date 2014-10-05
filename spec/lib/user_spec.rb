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
	end
  end
  describe 'add_to_cart' do
    it 'adds item to cart' do
	  user = User.new(:username =>'test', :password =>'test')
	  game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)	  
	  expect{ user.add_to_cart(game) }.to change{user.cart.price}.by(10)
	  expect(user.cart.itemlist).to include(game)
	end
  end
  describe 'clear_cart' do
  end
end