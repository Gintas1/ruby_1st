#main game class
require_relative 'user'
require_relative 'admin'
require_relative 'game'
require_relative 'comment'
require_relative 'purchase'
require_relative 'cart'
class Shop
  attr_accessor :users, :games, :current_user, :name, :price_modifier,
                :currency, :sales
  
  def initialize
    @sales = []
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
	  puts
      puts 'what would you like to do?'
      puts 'reg - register'
      puts 'login - to login'
      puts 'exit - to exit'
      action = gets.downcase.rstrip!
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
      if gets.downcase.rstrip! == 'y'
        break
      end
      puts 'enter username:'
      username = gets.downcase.rstrip!
      puts 'enter password'
      password = gets.downcase.rstrip!
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
      if gets.downcase.rstrip! == 'y'
        break
      end
	  puts 'enter username'
	  username = gets.downcase.rstrip!
	  puts 'enter password'
	  password = gets.downcase.rstrip!
      @current_user = @users.find { |user| user.check_data(username, password) }
	  puts @current_user
	  if @current_user.is_a?(User) || @current_user.is_a?(Admin)
        puts 'you have loged in'
		main_window
        break
      else
        puts 'Wrong username or password'
      end
    end
  end
  
  def main_window
    puts 'welcome ' + @current_user.username
	loop do
	puts
      puts 'what would you like to do?'
	  puts 'logout - to logout'
	  puts 'delete - to delete your account'
	  puts 'user - to view your account'
	  puts 'games - to view all games'
	  puts 'currency - to change currency game prices are shown'
	  action = gets.downcase.rstrip!
	  case action
	    when 'logout'
          @current_user = nil
		  break
		when 'delete'
		  @users.delete(@current_user)
		  @current_user = nil
		  break
		when 'user'
		  user_window
		when 'games'
		  gamelist_window
		when 'currency'
          change_currency
		else
		  puts 'wrong action'
      end
	end
  end
  
  def change_currency
    puts
    puts 'select currency from avalible' + @price_modifier.keys.to_s
	selection = gets.downcase.rstrip!
	case selection
	  when 'ltl'
	    @currency = 'LTL'
	  when 'eur'
	    @currency = 'EUR'
	  else
	    puts 'wrong selection'
	end
	puts @currency
  end

  def user_window
    
  end

  def gamelist_window
    loop do
	  puts
	  puts 'the folowing is a list of games we have to offer(name price)'
	  @games.each{ |game| puts game.name + ' ' + (game.price * @price_modifier[@currency])
	              .round(2).to_s + @currency }
	  puts 'what would you like to do?'
	  puts 'inspect - to further inspect selected game'
	  puts 'add - to add selected game to your cart'
	  puts 'back - to return to main window'
	  action = gets.downcase.rstrip!
	  case action
	    when 'inspect'
		  puts 'type a name of a game you want to inspect'
		  game_name = gets.downcase.rstrip!
		  selected_game = @games.find { |game| game.name.downcase == game_name }
		  if selected_game.is_a?(Game) 
		    selected_game_window(selected_game)
		  else
		    puts 'game not found'
		  end
		when 'add'
		  puts 'type a name of a game you want to inspect'
		  game_name = gets.downcase.rstrip!
		  selected_game = @games.find { |game| game.name.downcase == game_name }
		  if selected_game.is_a?(Game) 
		    puts 'how many would you like to add?(1..10)'
		    num = gets.to_i
		    if num.between?(1, 10)
			  @current_user.add_to_cart(selected_game, num)
			else
			  @current_user.add_to_cart(selected_game)
			end
		  else
		    puts 'game not found'
		  end
		when 'back'
		  break
	    else
		  puts 'wrong selection'
	  end
	end
  end
  
  def selected_game_window(game)
    loop do
	  puts
      puts 'Game name: ' + game.name
	  puts 'Game genre: ' + game.genre 
	  puts 'Game description: ' + game.description
	  puts 'Game price(' + @currency + '): ' + (game.price * 
	                                            @price_modifier[@currency])
	  										  .round(2).to_s
	  puts 'comments:'
	  game.comments.each { |x| puts x.id.to_s + ' ' + x.time.to_s + ' ' + x.user.username + ' ' + x.text }
	  if game.ratings.empty?
	    puts 'Game rating: no ratings yet'
	  else
	    puts 'Game rating: ' + (game.ratings.values.instance_eval { reduce(:+) / size.to_f}).to_s
	  end
	  puts
	  puts 'what would you like to do?'
	  puts 'add - to add this game to cart'
	  puts 'back - to return to game list window'
	  action = gets.downcase.rstrip!
	  case action
	    when 'add'
		  puts 'how many would you like to add?(1..10)'
		  num = gets.to_i
		  if num.between?(1, 10)
		    @current_user.add_to_cart(game, num)
		  else
		    @current_user.add_to_cart(game)
		  end
		when 'back'
		  break
		else
		  puts 'wrong selection'
      end
	end
  end

end
shop = Shop.new
game = Game.new(name: 'game1', genre: 'Genre test',
                description: 'Game description test', price: 10)
user = User.new(username: 'a', password: 'a')
user2 = User.new(username: 'b', password: 'b')
game.ratings[user] = 5
game.ratings[user2] = 1
game.comments.push(Comment.new(user: user, id: 2, text: 'labas'))
game.comments.push(Comment.new(user: user, id: 3, text: 'vakaras'))
shop.users.push(user)
shop.users.push(user2)
shop.games.push(game)
shop.games.push(Game.new(name: 'game2', genre: 'Genre test',
                      description: 'Game description test', price: 20))
shop.games.push(Game.new(name: 'game3', genre: 'Genre test',
                      description: 'Game description test', price: 30))
shop.begin
#admin = Admin.new(username: 'test', password: 'test')
#admin.sort
