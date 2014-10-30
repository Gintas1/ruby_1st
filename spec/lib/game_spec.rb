require 'rspec'
require 'spec_helper'
require 'game'

describe Game do
  describe '#initialize' do
    it 'checks name of a new game'do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.name).to eq('Game name test')
    end
    it 'checks genre of a new game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.genre).to eq('Genre test')
    end
    it 'checks a description of a new game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.description).to eq('Game description test')
    end
    it 'checks price of a new game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.price).to eq(10)
    end
    it 'checks comments of a new game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.comments).to match_array([])
    end
    it 'checks ratings of a new game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect(game.ratings).to match({})
    end
  end
  describe 'receives ratings' do
    it 'checks if a received rating is from a user' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.rate(user: 1, rating: 1) }.to raise_error
    end
    it 'checks if error was raised if received rating is invalid' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.rate(user: user, rating: 6) }.to raise_error
    end
    it 'checks if ratings has changed oafter receiving a valid rating' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.rate(user: user, rating: 4) }.to change { game.ratings }
    end
    it 'checks if error was raised after rating a game second time' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      game.rate(user: user, rating: 5)
      expect { game.rate(user: user, rating: 5) }.to raise_error
    end
  end
end
