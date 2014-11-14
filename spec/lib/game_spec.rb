require 'rspec'
require 'spec_helper'
require 'game'

describe Game do
  before :each do
    User.clear
    Purchase.clear_sales
    Game.clear
  end

  describe '#initialize' do
    it 'checks if games include game after creation' do
      game = Game.new_game('Game', 'Genre', 'description', 10)
      expect(Game.games).to include(game)
    end
  end
  describe 'validation' do
    it 'checks game name validation' do
      Game.new(name: 'Game name test', genre: 'Genre test',
               description: 'Game description test', price: 10)
      expect(Game.invalid_name?('Game name test')).to be true
    end
  end
  describe 'receives ratings' do
    it 'checks if ratings has changed oafter receiving a valid rating' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.rate(user: user, rating: 4) }.to change { game.ratings }
    end
  end
  describe 'receives comment' do
    it 'checks if comment was added' do
      user = User.new(username: 'test', password: 'test')
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.add_comment(user.id, 'text') }
             .to change { game.comments }.from([]).to([Comment])
    end
  end
  describe 'return' do
    it 'checks if get_by_id is returning a game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      ret = Game.get_by_id(1)
      expect(ret).to eq(game)
    end
    it 'checks if get_by_name is returning a game' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      ret = Game.get_by_name('Game name test')
      expect(ret).to eq(game)
    end
  end
  describe 'deletes' do
    it 'checks if game wa deleted after deleting it' do
      game = Game.new(name: 'Game name test', genre: 'Genre test',
                      description: 'Game description test', price: 10)
      expect { game.delete }.to change { Game.games }.from([game]).to([])
    end
  end
  describe 'edits' do
    it 'checks if editing game price changes its price' do
      game = Game.new_game('name', 'desc', 'genre', 10)
      expect { game.edit_price(20) }.to change { game.price }.from(10).to(20)
    end
    it 'checks if editing game description changes its description' do
      game = Game.new_game('name', 'desc', 'genre', 10)
      expect { game.edit_description('description') }
             .to change { game.description }.from('desc').to('description')
    end
    it 'checks if editing comment changes it' do
      game = Game.new_game('name', 'desc', 'genre', 10)
      user = User.register('test', 'test')
      game.add_comment(user.id, 'c')
      expect { game.edit_comment(1, 'com') }
              .to change { game.get_comment_by_id(1).text }.from('c').to('com')
    end
  end
  describe 'filter' do
    it 'checks if game filtering works' do
      Game.new_game('name', 'desc', 'genre', 10)
      Game.new_game('name1', 'desc', 'genre', 20)
      filtered = Game.filtered_games(15, 25)
      expect(filtered.count).to eq(1)
    end
  end
  describe 'list' do
    it 'checks if comment list was returned' do
      game = Game.new_game('name', 'desc', 'genre', 10)
      user = User.register('test', 'test')
      game.add_comment(user.id, 'comment')
      comments = game.comments
      expect(comments).to eq(game.comments)
    end
  end
  describe 'saves/loads' do
    it 'from/to file' do
      Game.new_game('name', 'desc', 'genre', 10)
      games = Game.all_games.map(&:name)
      Game.save_to_file('test.yaml')
      Game.clear
      Game.load_from_file('test.yaml')
      gms = Game.games.map(&:name)
      expect(games).to eq(gms)
    end
  end
end
