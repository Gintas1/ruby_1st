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
    @cart.itemlist.push(item)
	@cart.price += item.price
  end
  
  def clear_cart
    @cart.price = 0
	@cart.itemlist = []
  end
end