class Game
  attr_accessor :price, :description, :name, :genre, :comments, :ratings
  def initialize(data)
    @name = data[:name]
	@description = data[:description]
	@genre = data[:genre]
	@price = data[:price]
	@comments = []
	@ratings = []
  end
end