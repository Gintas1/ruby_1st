#main game class
require_relative 'user'
require_relative 'admin'
require_relative 'game'
require_relative 'comment'
require_relative 'purchase'
require_relative 'cart'
class Shop
  attr_accessor :users, :games, :current_user, :name
  def initialize
    @users = []
	@games = []
	@current_user = nil
	@price_modifier = {'LTL' => 1 ,'EUR' => 0.289}
	@currency = 'LTL'
	@name = 'pavadinimas'
  end
  
  def begin
    puts 'welcome to online store ' + @name
    loop do
      puts 'what would you like to do?'
      puts 'reg - register'
      puts 'login - to login'
      puts 'exit - to exit'
      puts
      action = gets
      action.rstrip!
      case action
        when 'reg'
          register
        when 'login'
          login
        when 'exit'
          break
        else
          puts 'wrong action'
          puts
      end
    end
  end
  
  def register
    loop do
      puts 'do you want to go back? [y/n]'
      if gets.rstrip! == 'y'
        break
      end
      puts 'enter username:'
      username = gets
      username.rstrip!
      puts 'enter password'
      password = gets
      password.rstrip!
      if @users.any? { |user| user.check_username(username) }
        puts 'username is already in use'
        puts
      else
        @users.push(User.new(username: username, password:password))
        puts 'succes! you have registered'
        puts
        break
      end
    end
  end
  
  def login
    loop do
      puts 'do you want to go back?[y/n]'
      if gets.rstrip! == 'y'
        break
      end
	  puts 'enter username'
	  username = gets.rstrip!
	  puts 'enter password'
	  password = gets.rstrip!
      @current_user = @users.find { |user| user.check_data(username, password) }
	  puts @current_user
	  if @current_user.is_a?(User) || @current_user.is_a?(Admin)
        puts 'you have loged in'
        break
      else
        puts 'Wrong username or password'
      end
    end
  end
end

shop = Shop.new
#shop.users.push(User.new(username: 'a', password: 'a'))
shop.begin

#admin = Admin.new(username: 'test', password: 'test')
#admin.sort
