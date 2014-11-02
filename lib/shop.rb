#main game class
require_relative 'user'
require_relative 'admin'
require_relative 'game'
require_relative 'comment'
require_relative 'purchase'
require_relative 'message'
require_relative 'cart'
require 'yaml'
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
		  save
          break
        else
          puts 'wrong action'
          puts
      end
    end
  end
  
  def save
    File.open("shop.yaml", "w") do |file|
	  file.puts YAML::dump(self)
	  file.puts ""
	end
  end
  
  def register
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
    end
  end
  
  def login
    puts 'enter username'
    username = gets.downcase.rstrip!
    puts 'enter password'
    password = gets.downcase.rstrip!
    @current_user = @users.find { |user| user.check_data(username, password) }
    if @current_user.is_a?(User) || @current_user.is_a?(Admin)
      if @current_user.blocked
        puts 'this user is blocked'
      else
        puts 'you have loged in'
        main_window
      end
    else
      puts 'Wrong username or password'
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
	  if @current_user.is_a?(Admin)
	    puts 'users - to see all avalible users'
        puts 'name - to change sop name'
		puts 'sales - to view info about sales'
	  end
      action = gets.downcase.rstrip!
      case [action, true]
        when ['logout', @current_user.is_a?(User)]
          @current_user = nil
          break
        when ['delete', @current_user.is_a?(User)]
          @users.delete(@current_user)
          @current_user = nil
          break
        when ['user', @current_user.is_a?(User)]
          user_window
        when ['games', @current_user.is_a?(User)]
          gamelist_window
        when ['currency', @current_user.is_a?(User)]
          change_currency
		when ['users', @current_user.is_a?(Admin)]
		  users_list
		when ['name', @current_user.is_a?(Admin)]
		  change_name
		when ['sales', @current_user.is_a?(Admin)]
		  view_sales
        else
          puts 'wrong action'
      end
    end
  end
  
  def view_sales
    puts 'all sales:'
    @sales.each { |sale| puts
                         puts sale.buyer.username
                         puts 'time: ' + sale.time.to_s
						 puts 'sold items:'
                         sale.items.each { |item, amount| puts item.name + ' x' + amount.to_s } 
						 puts sale.price}
  end
  
  def change_name
    puts
    puts 'current shop name is: ' + @name
    puts 'enter new name:'
    @name = gets.rstrip!
    puts 'shop name successfuly changed to: ' + @name
  end
  
  def users_list
    loop do
	  puts
	  puts 'currently registered users: '
	  @users.each { |user| puts user.username + ' ' + user.class.to_s + ' ' + user.blocked.to_s}
	  puts 'what woud you like to do?'
	  puts 'block - to blosck user'
	  puts 'unblock - to unblock user'
	  puts 'admin - to add admin'
	  puts 'credit - to edit users credit'
	  puts 'purchases - to wiev user purchases'
	  puts 'info - to view user info'
	  puts 'back - to go back'
	  action = gets.downcase.rstrip!
	  case action
	    when 'block'
          block_user
		when 'unblock'
		  unblock_user
		when 'admin'
		  add_admin
		when 'credit'
		  edit_credit
		when 'purchases'
		  get_purchases
		when 'info'
		  get_user_info
		when 'back'
		  break
		else 
		  puts 'wrong action'
	  end
	end
  end
  
  def get_user_info
    puts 'enter a name of a user you want to inspect'
	name = gets.downcase.rstrip!
	user = @users.find { |user| user.username.downcase == name }
	if user.is_a?(User)
	puts 'username, balance, gamelist, is blocked'
	  info = @current_user.get_user_info(user)
	  puts info[0]
	  puts info[1]
	  info[2].each { |item| puts item.name }
	  puts info[3]
	  
	else
	  puts 'could not find this user'
	end
  end
  
  def get_purchases
    puts 'enter name of a user, to view his purchase history'
	name = gets.downcase.rstrip!
	user = @users.find { |user| user.username.downcase == name }
	if user.is_a?(User)
	  @current_user.get_user_purchases(user).each { |purchase| puts purchase.time.to_s
                                                    purchase.items.each { |item, amount| puts item.name + ' x' + amount.to_s }
                                					puts purchase.price 
													puts}
	else
	  puts 'could not find this user'
	end
  end
  
  def edit_credit
    puts 'enter a name of a user you want to grant credit'
	username = gets.downcase.rstrip!
	user = @users.find { |user| user.username.downcase == username }
	puts 'enter ammount of credits you want the user to have'
	credit = gets.to_i
	if !(user.is_a?(User))
	  puts 'could not find user'
	elsif credit < 0
	  puts 'invalid amount of credits'
	else
	  @current_user.edit_user_balance(user, credit)
	  puts 'user: ' + user.username + ' now has ' + user.balance.to_s + ' credits'
	end
  end
  
  def add_admin
    puts 'enter username of a new admin'
	username = gets.rstrip!
	puts 'enter password of a new admin'
    password = gets.rstrip!
	@users.push(Admin.new(username:username, password:password))
	puts 'Admin: ' + username + ' created'
  end
  
  def block_user
    puts 'enter name of a user you want to block'
	name = gets.downcase.rstrip!
	user = @users.find { |user| user.username.downcase == name }
	if user.class == User
	  @current_user.block_user(user)
	else
	  puts 'user does not exist, or cannot be blocked'
	end
  end
  
  def unblock_user
    puts 'enter name of a user you want to block'
	name = gets.downcase.rstrip!
	user = @users.find { |user| user.username.downcase == name }
	if user.class == User
	  @current_user.unblock_user(user)
	else
	  puts 'user does not exist, or cannot be unblocked'
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
      puts 'send - to write a message'
      puts 'messages - to view messages'
	  puts 'read - to read a message'
      puts 'games - to wiev a list of games you own'
      puts 'purchases - to see you purchase history'
      puts 'cart - to wiev a cart'
      puts 'sort - to sort a gamelist'
      puts 'back - to go back'
      action = gets.downcase.rstrip!
      case action
        when 'send'
          send_message
        when 'messages'
          print_messages
        when 'read'
          read_message
        when 'games'
          print_game_list
        when 'purchases'
          print_purchases
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
  
  def print_purchases
    @current_user.purchases.each { |purchase| puts
                                  puts purchase.time
                                  purchase.items.each {
                                  |item, number| puts item.name +
								  ' x' + number.to_s }
                                  puts purchase.price }
  end
  
  def print_game_list
    @current_user.gamelist.each { |game| puts game.name +
	                              ' ' + game.description }
  end
  
  def read_message
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
  end
  
  def print_messages
    puts 'your messages(id, read?, date, sender, topic):'
    @current_user.messages.each { |message| puts message.id.to_s + ' ' +
                                 message.read.to_s + ' ' +
                                 message.date.to_s + ' ' + 
                                 message.sender.username + ' ' + 
                                 message.topic }
  end
  
  def cart
    loop do
      puts
      puts 'content of your cart:'
      @current_user.cart.itemlist.each { |item, number| puts item.name +
	                                     ' ' + item.price.to_s +
										 ' x' + number.to_s }
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
          @sales.push(@current_user.buy)
        when 'remove'
          remove_from_cart
        when 'back'
          break
      end
    end
  end
  
  def remove_from_cart
    puts 'type item name you want to remove'
    name = gets.downcase.rstrip!
    item = @current_user.cart.itemlist.keys.find { |i| 
	                                               i.name.downcase == name }
    if item.is_a?(Game)
      @current_user.remove_from_cart(item)
    else
      puts 'item not found in your cart'
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
	  if @current_user.is_a?(Admin)
	    puts 'new - to add a new game'
		puts 'remove - to remove game from the list'
      end
      puts 'inspect - to further inspect selected game'
      puts 'add - to add selected game to your cart'
      puts 'filter - to filter gamelist by price range'
      puts 'back - to return to main window'
      action = gets.downcase.rstrip!
      case [action, true]
        when ['inspect', @current_user.is_a?(User)]
          inspect_game
        when ['add', @current_user.is_a?(User)]
          add_game_to_cart
        when ['back', @current_user.is_a?(User)]
		  filter = false
          lower_value = 0
          upper_value = 0
          break
        when ['filter', @current_user.is_a?(User)]
          puts 'enter lover value'
          lower_value = gets.to_i
          puts 'enter upper value'
          upper_value = gets.to_i
          if upper_value >= lower_value
            filter = true
          else
            puts 'wrong values'
          end
		when ['new',@current_user.is_a?(Admin)]
		  add_new_game
		when ['remove',@current_user.is_a?(Admin)]
		  remove_game
        else
          puts 'wrong selection'
      end
    end
  end
  
  def remove_game
    puts 'enter a name of a game you want to remove'
	name = gets.downcase.rstrip!
	game = @games.find { |game| game.name.downcase == name }
	if game.is_a?(Game)
	  @current_user.remove_game(game, @games)
	end
  end
  
  def add_new_game
    puts 'enter a name of a game:'
	name = gets.rstrip!
	puts 'ender description of a game:'
	description = gets.rstrip!
	puts 'enter a price of a game:'
	price = gets.to_i
	puts 'enter genre of a game'
	genre = gets.rstrip!
	if @games.any? { |game| game.name.downcase == name }
	  puts 'game with this name already in use'
	else
	  @games.push(@current_user.add_game(name: name, description: description, price: price, genre: genre))
	  puts 'Item named: ' + name + ' successfully created'
    end
  end
  
  def add_game_to_cart
    puts 'type a name of a game you want to add to your cart'
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
  end
  
  def inspect_game
    puts 'type a name of a game you want to inspect'
    game_name = gets.downcase.rstrip!
    selected_game = @games.find { |game| game.name.downcase == game_name }
    if selected_game.is_a?(Game) 
	  selected_game_window(selected_game)
	else
      puts 'game not found'
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
	  if @current_user.is_a?(Admin)
	    puts 'price - to edit game price'
		puts 'desc - to edit game description'
		puts 'edit - to edit selected comment'
	  end
      puts 'add - to add this game to cart'
      puts 'comment - to comment this game'
      puts 'rate - to rate this game'
      puts 'back - to return to game list window'
      action = gets.downcase.rstrip!
      case [action, true]
        when ['add', @current_user.is_a?(User)]
          add_game(game)
        when ['back', @current_user.is_a?(User)]
          break
        when ['comment', @current_user.is_a?(User)]
          comment_game(game)
        when ['rate', @current_user.is_a?(User)]
          rate_game(game)
		when ['price', @current_user.is_a?(Admin)]
		  change_price(game)
		when ['desc', @current_user.is_a?(Admin)]
		  change_description(game)
		when ['edit', @current_user.is_a?(Admin)]
		  edit_comment(game)
        else
          puts 'wrong selection'
      end
    end
  end
  
  def change_price(game)
    puts 'current game price is: ' + game.price.to_s + ' LTL'
	puts 'enter new price for this game'
	price = gets.to_i
	if price >= 0
	  @current_user.edit_game_price(game, price)
	else
	  puts 'invalid price'
	end
  end
  
  def change_description(game)
    puts 'current descrription of a game is: '
	puts game.description
	puts 'enter new description for this game'
	description = gets.rstrip!
	@current_user.edit_game_description(game, description)
  end
  
  def edit_comment(game)
    puts 'type id of a omment you want to edit: '
	id = gets.to_i
	puts 'type a new comment'
	text = gets.rstrip!
	comment = game.comments.find { |comment| comment.id == id }
	if comment.is_a?(Comment)
	  @current_user.edit_comment(comment, text)
	else
	  puts 'comment not found'
	end
  end
  
  def add_game(game)
    puts 'how many would you like to add?(1..10)'
    num = gets.to_i
    if num.between?(1, 10)
      @current_user.add_to_cart(game, num)
    else
      @current_user.add_to_cart(game)
    end
  end
  
  def comment_game(game)
    puts 'what would you like to say about this game?'
    comment = gets.rstrip!
    @current_user.comment_game(game: game, text: comment)
  end
  
  def rate_game(game)
    puts 'how would you rate this game?'
    rate = gets.to_i
    @current_user.rate_game(game: game, rating: rate)
  end

end
shop = Shop.new
File.open("shop.yaml", "r") do |obj|
  shop = YAML::load(obj)
end
#game = Game.new(name: 'game1', genre: 'Genre test',
                #description: 'Game description test', price: 10)
#user = User.new(username: 'a', password: 'a')
#user.balance = 100
#user2 = Admin.new(username: 'b', password: 'b')
#user2.balance = 100
#shop.users.push(user)
#shop.users.push(user2)
#shop.games.push(game)
#shop.games.push(Game.new(name: 'game2', genre: 'Genre test',
                     # description: 'Game description test', price: 20))
#shop.games.push(Game.new(name: 'game3', genre: 'Genre test',
                     # description: 'Game description test', price: 30))
shop.begin
#admin = Admin.new(username: 'test', password: 'test')
#admin.sort
