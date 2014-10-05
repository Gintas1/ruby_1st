require 'rspec'
require 'spec_helper'
require 'game'

describe Game do
  describe '#initialize' do
    it 'sets new game'do
	  game = Game.new(:name => 'Game name test', genre => 'Genre test', description => 'Game destription test', price=> 10)
	  expect(game.name).to eq('Game name test')
	  expect(game.genre).to eq('Genre test')
	  expect(game.destription).to eq('Game destription test')
	  expect(game.price).to eq(10)
	end
  end
end