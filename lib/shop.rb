require_relative 'purchase'
require_relative 'user'
require_relative 'game'
require_relative 'comment'
require_relative 'cart'
require_relative 'message'
# main game class
class Shop
  attr_accessor :current_user, :name, :price_modifier, :currency

  def initialize
    User.load_from_file
    Game.load_from_file
    Purchase.load_from_file
    @current_user = nil
    @price_modifier = { 'LTL' => 1, 'EUR' => 0.289 }
    @currency = 'LTL'
    @name = 'pavadinimas'
    start
  end

  def start
    puts 'welcome to online store ' + @name
    loop do
      puts
      puts 'type "help", to get help'
      action = gets.downcase.rstrip!
      case action
      when 'register'
        register
      when 'logout'
        logout
      when 'delete'
        delete
      when 'help'
        help
      when 'login'
        login
      when 'users'
        users
      when 'add_game'
        add_game
      when 'games'
        games
      when 'block'
        block
      when 'unblock'
        unblock
      when 'inspect'
        inspect
      when 'rate_game'
        rate_game
      when 'comment'
        comment_game
      when 'add_to_cart'
        add_to_cart
      when 'view_cart'
        view_cart
      when 'clear_cart'
        clear_cart
      when 'edit_balance'
        edit_balance
      when 'buy'
        buy
      when 'gamelist'
        view_gamelist
      when 'purchases'
        view_purchases
      when 'sales'
        view_sales
      when 'Remove_game'
        remove_game
      when 'exit'
        logout if @current_user && @current_user.logged_in
        break
      else
        puts 'wrong action'
      end
    end
  end

  def help
    puts 'register - to register'
    puts 'login - to login'
    puts 'logout - to logout'
    puts 'delete - to delete your account'
    puts 'Users - to see a list of all users'
    puts 'Games - to view all games'
    puts 'exit - to exit'
    puts 'inspect - to further inspect a selected game'
    puts 'rate_game - to rate a game'
    puts 'comment - to comment selected game'
    puts 'Add_to_cart - to add item to cart'
    puts 'View_cart - to view your cart'
    puts 'clear_cart - to clear your cart'
    puts 'buy - to buy a content of your cart'
    puts 'gamelist - to view your gamelist'
    puts 'purchases - to view your purchases'
    return unless admin?
    puts 'Admin commands:'
    puts 'Remove_game - to remove a game from the shop'
    puts 'sales - to view sales'
    puts 'Add_game - to create a new game'
    puts 'block - to block selected user'
    puts 'unblock - to unblock selected user'
    puts 'edit_balance - to edit users balance'
  end

  def buy
    if @current_user
      @current_user.buy
    else
      puts 'you need to login to buy something'
    end
  end

  def remove_game
    return unless admin?
    puts 'enter ID of a game you want to remove'
    id = gets.to_i
    if !(game = Game.get_by_id(id)).nil?
      game.delete
    else
      puts 'could not find item with such ID'
    end
  end

  def view_sales
    return unless admin?
    Purchase.sale_info.each do |sale|
      puts "ID: #{sale.id}\nBuyer:#{sale.buyer.username}\nTime:#{sale.time}\n"\
           "Price: #{sale.price}\nItems bought:"
      sale.items.each { |item, amount| puts "#{item.name} x#{amount}" }
      puts
    end
  end

  def view_gamelist
    if @current_user
      @current_user.gamelist.each do |game|
        puts "Name: #{game.name}, Genre #{game.genre}"
      end
    else
      puts 'you need to login to view your gamelist'
    end
  end

  def view_purchases
    if @current_user
      @current_user.purchases.each do |purchase|
        puts "ID: #{purchase.id}\nTime: #{purchase.time}\n"\
             "price: #{purchase.price}\nItems:"
        purchase.items.each { |item, amount| puts "#{item.name} x#{amount}" }
        puts
      end
    else
      puts 'you need to login to view your purchase'
    end
  end

  def edit_balance
    return unless admin?
    puts 'enter ID of a user whos balance you want to edit'
    id = gets.to_i
    if !(user = User.get_by_id(id)).nil?
      puts 'enter a new balance'
      user.edit_balance(gets.to_i)
    else
      puts 'could not find user with such ID'
    end
  end

  def add_to_cart
    if @current_user
      puts 'One by one enter ID of an item you want to add and amount'
      id = gets.to_i
      amount = gets.to_i
      @current_user.add_to_cart(id, amount)
    else
      puts 'login to add items to cart'
    end
  end

  def view_cart
    if @current_user
      @current_user.cart.itemlist.each { |x, y| puts "#{x.name} x#{y}" }
      puts "Price: #{@current_user.cart.price}"
    else
      puts 'you need to login to view your cart'
    end
  end

  def clear_cart
    if @current_user
      @current_user.clear_cart
      puts 'your cart was cleared'
    else
      puts 'you need to login to clear your cart'
    end
  end

  def rate_game
    return unless @current_user
    puts 'enter ID of a game you want to inspect'
    id = gets.to_i
    if !(game = Game.get_by_id(id)).nil?
      puts 'enter a rating from 1 to 5'
      rating = gets.to_i
      game.rate(user: @current_user, rating: rating)
    else
      puts 'game with such ID does not exist'
    end
  end

  def comment_game
    return unless @current_user
    puts 'enter ID of a game you want to comment'
    id = gets.to_i
    if !(game = Game.get_by_id(id)).nil?
      puts 'What would you like to say about this game?'
      text = gets.rstrip!
      game.add_comment(@current_user.id, text)
    else
      puts 'game with such ID does not exist'
    end
  end

  def inspect
    puts 'enter ID of a game you want to inspect'
    id = gets.to_i
    if !(game = Game.get_by_id(id)).nil?
      puts "ID: #{game.id}\nName: #{game.name}\nGenre: #{game.genre}\n"\
           "Description: #{game.description}\nPrice: #{game.price}\n"\
           "Rating: #{game.rating}\nComments(ID, name, time, comment):"
      game.comments.each do |comment|
        puts "#{comment.id}, #{comment.user.username}, #{comment.time}"\
             "#{comment.text}\n"
      end
    else
      puts 'game with such ID does not exist'
    end
  end

  def block
    return unless admin?
    puts 'Enter an ID of a iser you want to block'
    id = gets.to_i
    if !(user = User.get_by_id(id)).nil?
      user.block
      puts "You have blocked user: #{user.username}"
    else
      puts 'user with such id does not exist'
    end
  end

  def unblock
    return unless admin?
    puts 'Enter an ID of a iser you want to unblock'
    id = gets.to_i
    if !(user = User.get_by_id(id)).nil?
      user.unblock
      puts "You have unblocked user: #{user.username}"
    else
      puts 'user with such id does not exist'
    end
  end

  def games
    puts 'folowing is a list of all games (id, name, genre, price):'
    Game.all_games.each do |game|
      puts "#{game.id}, #{game.name}, #{game.genre} #{game.price}"
    end
  end

  def add_game
    return unless admin?
    data = game_data
    if Game.new_game(data[0], data[1], data[2], data[3])
      puts 'game succesfuly created'
    else
      puts 'Something is wrong, game was not created'
    end
  end

  def game_data
    puts 'One by one enter (Name, Description, genre, price) of a new game'
    name = gets.rstrip!
    description = gets.rstrip!
    genre = gets.rstrip!
    price = gets.to_f
    [name, description, genre, price]
  end

  def users
    if @current_user
      puts
      puts 'User list (id, username, status):'
      User.all_users.each do |user|
        puts "#{user.id}, #{user.username},  #{user.admin ? 'Admin' : 'User'}"\
             ", #{user.blocked ? 'Blocked' : 'Not blocked'}"
      end
    else
      puts 'you need to login to view all users'
    end
  end

  def register
    puts 'enter username:'
    username = gets.rstrip!
    puts 'enter password'
    password = gets.rstrip!
    if User.register(username, password)
      puts 'Succes! you have registered'
    else
      puts 'Username is already in use'
    end
  end

  def login
    logout if @current_user
    puts 'enter username'
    username = gets.rstrip!
    puts 'enter password'
    password = gets.rstrip!
    if !(@current_user = User.login(username, password)).nil?
      puts 'you have loged in'
    else
      puts 'Wrong username or password'
    end
  end

  def logout
    if @current_user && @current_user.logged_in
      @current_user.logged_in = false
      @current_user = nil
      puts 'You have logged out'
    else
      puts 'you need to be logged in to log out'
    end
  end

  def delete
    if @current_user && @current_user.logged_in
      @current_user.delete
      @current_user = nil
      puts 'you have deleted your account'
    else
      puts 'you need to be logged in to delete your account'
    end
  end

  def admin?
    if @current_user && @current_user.admin
      true
    else
      puts 'You do not have a permition to perform this action'
      false
    end
  end
end

Shop.new
