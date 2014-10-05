require_relative 'cart'
class User
  attr_accessor :username, :password, :balance, :cart, :gamelist
  def initialize(data)
    @username = data[:username]
	@password = data[:password]
	@balance = 0
	@cart = Cart.new
	@gamelist = []
  end
  
  def add_to_cart(item)
    if (item.is_a?(Game))
	  if(cart.itemlist.include? item)
	    raise StandartError, 'item is alredy in a cart'
      else
        @cart.itemlist.push(item)
	    @cart.price += item.price
      end
	else
	  raise TypeError, 'item should be instance of a game'
	end
  end
  
  def clear_cart
    @cart.price = 0
	@cart.itemlist = []
  end
  
  def remove_from_cart(item)
    if(item.is_a?(Game))
      if(cart.itemlist.include? item)
	    @cart.itemlist.delete(item)
	    @cart.price -= item.price
	  else
	    raise StandartError, 'item you want to remove is not in a list'
      end
	else
	  raise TypeError, 'item instance is not a type of a Game'
	end
  end
end