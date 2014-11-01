#main game class
require_relative 'user'
require_relative 'admin'
require_relative 'game'
require_relative 'comment'
require_relative 'purchase'
require_relative 'message'
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
	    if @current_user.blocked
		  puts 'this user is blocked'
		else
          puts 'you have loged in'
		  main_window
          break
		end
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
    puts
	loop do
	  puts
      puts 'welcome to your user profile, ' + @current_user.username + ' your balance now is: ' + @current_user.balance.to_s
	  puts 'what would you like to do?'
	  puts 'send - to white a message'
	  puts 'messages - t view messages'
	  puts 'games - to wiev a list of games you own'
	  puts 'purchases - to see see you purchase history'
	  puts 'cart - to wiev a cart'
	  puts 'sort - to sort a gamelist'
	  puts 'back - to go back'
	  action = gets.downcase.rstrip!
	  case action
	    when 'send'
		  send_message
		when 'messages'
		  puts 'your messages(id, read?, date, sender, topic):'
		  @current_user.messages.each { |message| puts message.id.to_s + ' ' +
		                               message.read.to_s + ' ' +
		                               message.date.to_s + ' ' + 
									   message.sender.username + ' ' + 
									   message.topic }
		when 'read'
		  puts 'enter id of a message you want to read'
		  id = gets.to_i
		  message = @current_user.messages.find { |msg| msg.id ==id }
		  if message.is_a?(Message)
		    message.read = true
			puts 'time message was sent: ' + message.date.to_s
			puts 'sender: ' + message.sender.username
			puts 'topic: ' + message.topic
			puts 'message: ' + message.text
		  else
		    puts 'message not found'
		  end
		when 'games'
		  @current_user.gamelist.each { |game| puts game.name + ' ' + game.description }
		when 'purchases'
		  @current_user.purchases.each { |purchase| puts
                                  		 puts purchase.time
		                                 purchase.items.each {
										 |item, number| puts item.name + ' x' +number.to_s }
										 puts purchase.price }
		when 'cart'
		  cart
		when 'sort'
		  @current_user.sort
		when 'back'
		  break
		else
		  puts 'wrong selection'
	  end
	end
  end
  
  def cart
    loop do
	  puts
      puts 'content of your cart:'
	  @current_user.cart.itemlist.each { |item, number| puts item.name + ' ' + item.price.to_s + ' x' + number.to_s }
	  puts 'total: ' + @current_user.cart.price.to_s 
	  puts 'what would you like to do?'
	  puts 'clear - to clear cart'
	  puts 'buy - to buy items in a cart'
	  puts 'remove - to remove item from a cart'
	  puts 'back - to go back'
	  action = gets.downcase.rstrip!
	  case action
	    when 'clear'
		  @current_user.clear_cart
	    when 'buy'
		  @current_user.buy
	    when 'remove'
		  puts 'type item name you want to remove'
		  name = gets.downcase.rstrip!
		  item = @current_user.cart.itemlist.keys.find { |i| i.name.downcase == name }
		  if item.is_a?(Game)
		    @current_user.remove_from_cart(item)
		  else
		    puts 'item not found in your cart'
		  end
	    when 'back'
		  break
	  end
	end
  end
  
  def send_message
    puts
    puts 'enter name of a receiver'
	puts 'our current administrators:'
	@users.each { |user| print user.username + ' ' if user.is_a?(Admin) }
	puts
	name = gets.downcase.rstrip!
	puts 'type topic of a message'
	topic = gets
	puts 'type message'
	message = gets
	receiver = @users.find { |user| user.username.downcase == name }
	if (receiver.is_a?(User) || receiver.is_a?(Admin))
	  @current_user.send_message(text: message, topic: topic, receiver: receiver)
	  puts 'success! message sent'
	else
	  puts 'user does not exist'
	end
  end

  def gamelist_window
    filter = false
	lower_value = 0
	upper_value = 0
    loop do
	  puts
	  puts 'the folowing is a list of games we have to offer(name price)'
	  if filter
	    @games.each{ |game| puts game.name + ' ' + (game.price * @price_modifier[@currency])
	              .round(2).to_s + @currency if game.price.between?(lower_value, upper_value)}
	  else
	    @games.each{ |game| puts game.name + ' ' + (game.price * @price_modifier[@currency])
	              .round(2).to_s + @currency }
	  end
	  puts 'what would you like to do?'
	  puts 'inspect - to further inspect selected game'
	  puts 'add - to add selected game to your cart'
      puts 'filter - to filter gamelist by price range'
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
		when 'filter'
		  puts 'enter lover value'
		  lower_value = gets.to_i
		  puts 'enter upper value'
		  upper_value = gets.to_i
		  if upper_value >= lower_value
		    filter = true
		  else
		    puts 'wrong values'
		  end
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
	  puts 'comment - to comment this game'
	  puts 'rate - to rate this game'
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
		when 'comment'
		  puts 'what would you like to say about this game?'
		  comment = gets.rstrip!
		  @current_user.comment_game(game: game, text: comment)
		when 'rate'
		  puts 'how would you rate this game?'
		  rate = gets.to_i
		  @current_user.rate_game(game: game, rating: rate)
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
user.balance = 100
#user.purchases.push(Purchase.new(items: [Game.new(name: 'a', genre: 'b', description: 'c', price: 15)], price: 15))
user2 = Admin.new(username: 'b', password: 'b')
#game.ratings[user] = 5
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
