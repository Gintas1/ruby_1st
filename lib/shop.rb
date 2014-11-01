#main game class
require_relative 'user'
require_relative 'admin'
require_relative 'game'
require_relative 'comment'
require_relative 'purchase'
require_relative 'cart'
class Shop
  attr_accessor :users, :games, :current_user
  def initialize
    @users = []
	@games = []
	@current_user = nil
	@currency = ['LTL','EUR']
	@current_currency = 'LTL'
	@name = ''
  end
  
  def begin
  end
end

shop = Shop.new
#shop.begin
admin = Admin.new(username: 'test', password: 'test')
admin.sort
puts 'ello'