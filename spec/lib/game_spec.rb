require 'rspec'
require 'spec_helper'
require 'game'

describe Game do
  describe '#initialize' do
    it 'sets new game'do
	  game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)
	  expect(game.name).to eq('Game name test')
	  expect(game.genre).to eq('Genre test')
	  expect(game.description).to eq('Game description test')
	  expect(game.price).to eq(10)
	  expect(game.comments).to match_array([])
	  expect(game.ratings).to match({})
	end
  end
  describe ' receives' do
    it 'receives rating' do
	  user = User.new(:username =>'test', :password =>'test')
	  game = Game.new(:name => 'Game name test', :genre => 'Genre test', :description => 'Game description test', :price=> 10)
	  expect{game.rate(:user => 1, :rating => 1)}.to raise_error
	  expect{game.rate(:user => user, :rating => 6)}.to raise_error
	  expect{game.rate(:user => user, :rating => 4)}.to change{game.ratings}
	  expect{game.rate(:user => user, :rating => 5)}.to raise_error
	end
  end
end