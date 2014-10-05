class Game
  attr_accessor :price, :description, :name, :genre
  def initialize(data)
    @name = data[:name]
	@description = data[:description]
	@genre = data[:genre]
	@price = data[:price]
  end
end