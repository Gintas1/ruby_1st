require 'yaml'
# class for game
class Game
  attr_accessor :price, :description, :name, :genre, :comments, :ratings,
                :comment_count, :id, :rating
  class << self
    attr_accessor :games, :game_id
  end

  GAMES_FILE_NAME = 'games.yaml'

  begin
    @games = YAML.load(File.read(GAMES_FILE_NAME))
  rescue
    @games = []
  end

  @game_id = @games.count > 0 ? @games[@games.count - 1].id : 0

  def self.load_from_file(filename = GAMES_FILE_NAME)
    @games = YAML.load(File.read(filename))
    @game_id = @games.count > 0 ? @games[@games.count - 1].id : 0
  end

  def self.get_by_id(id)
    @games.find { |game| game.id == id }
  end

  def self.get_by_name(name)
    @games.find { |game| game.name.casecmp(name) == 0 }
  end

  def self.new_game(name, description, genre, price)
    if !invalid_name?(name) && price >= 0
      Game.new(name: name, description: description, genre: genre,
               price: price)
    end
  end

  def self.invalid_name?(name)
    @games.any? { |game| game.name.casecmp(name) == 0 } || name == ''
  end

  def self.filtered_games(lower_range, upper_range)
    if lower_range <= upper_range
      all_games
      @games.select { |game| (lower_range..upper_range).include? game.price }
    end
  end

  def self.clear
    @games = []
    @game_id = 0
    save_to_file
  end

  def self.all_games
    @games = YAML.load(File.read(GAMES_FILE_NAME))
  end

  def self.save_to_file(filename = GAMES_FILE_NAME)
    File.open filename, 'w' do |f|
      f.write YAML.dump(@games)
    end
  end

  def initialize(data)
    self.class.game_id += 1
    @id = self.class.game_id
    @name = data[:name]
    @description = data[:description]
    @genre = data[:genre]
    @price = data[:price]
    @comment_count = 0
    @comments = []
    @ratings = {}
    @rating = nil
    add
  end

  def add
    self.class.games.push(self)
    self.class.save_to_file
  end

  def rate(data)
    return unless !@ratings.key?(data[:user]) && (1..5).include?(data[:rating])
    @ratings[data[:user]] = data[:rating]
    @rating = (@ratings.values.instance_eval { reduce(:+) / size.to_f })
              .round(2)
    self.class.save_to_file
  end

  def edit_price(price)
    @price = price
    self.class.save_to_file
  end

  def edit_description(description)
    @description = description
    self.class.save_to_file
  end

  def edit_comment(comment_id, text)
    return if (comment = get_comment_by_id(comment_id)).nil?
    comment.text = text
    self.class.save_to_file
  end

  def get_comment_by_id(comment_id)
    @comments.find { |comment| comment.id == comment_id }
  end

  def add_comment(user_id, text)
    @comment_count += 1
    user = User.get_by_id(user_id)
    @comments.push(Comment.new(user: user, text: text, id: @comment_count))
    self.class.save_to_file
  end

  def delete
    self.class.games.delete(self)
    self.class.save_to_file
  end
end
