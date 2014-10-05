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
	  expect(game.ratings).to match_array([])
	end
  end
end