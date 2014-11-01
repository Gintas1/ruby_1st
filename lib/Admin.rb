#class for admin user
require 'user'
class Admin < User
  attr_accessor :admin_granted
  def initialize(data)
    super(data)
    @admin_granted = data[:admin_granted]
  end
  
  def add_game(data)
    Game.new(data)
  end
  
  def edit_game_price(game, price)
    game.price = price
  end
  
  def edit_game_description(game,description)
    game.description = description
  end
  
  def add_admin(data)
    Admin.new(data)
  end

end