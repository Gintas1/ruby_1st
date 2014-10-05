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
end