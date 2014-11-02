#class for admin user
require_relative 'user'
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
  
  def edit_game_description(game, description)
    game.description = description
  end
  
  def edit_comment(comment, text)
    comment.text = text
  end
  
  def add_admin(data)
    Admin.new(username: data[:username], password: data[:password] , admin_granted: self)
  end
  
  def remove_game(game, games)
    if games.include? game
      games.delete(game)
    else
      puts 'list does not contain this game'
    end
  end
  
  def block_user(user)
    user.blocked = true
  end
  
  def unblock_user(user)
    user.blocked = false
  end

  def edit_user_balance(user, balance)
    user.balance = balance
  end
  
  def get_user_purchases(user)
    return user.purchases
  end
  
  def get_user_info(user)
    return [user.username, user.balance, user.gamelist, user.blocked]
  end

end