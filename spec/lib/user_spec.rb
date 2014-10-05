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
end