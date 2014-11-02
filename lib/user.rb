# class for user
class User
  attr_accessor :username, :password, :balance,
                :cart, :gamelist, :purchases,
                :blocked, :messages, :message_id
  def initialize(data)
    @username = data[:username]
    @password = data[:password]
    @balance = 0
    @cart = Cart.new
    @gamelist = []
    @purchases = []
	@blocked = false
	@messages = []
	@message_id = 0
	
  end

  def add_to_cart(item, amount = 1)
    if item.is_a?(Game)
      if cart.itemlist.include? item
        @cart.itemlist[item] += amount
        @cart.price += amount * item.price
      else
        @cart.itemlist[item] = amount
        @cart.price += amount * item.price
      end
    else
      puts 'item should be instance of a game'
    end
  end

  def clear_cart
    @cart.price = 0
    @cart.itemlist = {}
  end

  def remove_from_cart(item)
    if item.is_a?(Game)
      if cart.itemlist.include? item
        @cart.price -= item.price * @cart.itemlist[item]
        @cart.itemlist.delete(item)
      else
        puts 'item you want to remove is not in a list'
      end
    else
      puts 'item instance is not a type of a Game'
    end
  end

  def buy
    return unless check_cart && check_balance
    @balance -= cart.price
    cart.itemlist.each { |x,y| y.times{@gamelist.push(x)} }
	purch = Purchase.new(price:cart.price, items: cart.itemlist.dup, buyer: self)
    @purchases.push(purch)
    clear_cart
    sort
	return purch
  end

  def check_cart
    if @cart.itemlist.empty?
      puts 'your cart is empty'
    else
      true
    end
  end

  def check_balance
    if @cart.price > @balance
      puts 'insufficient balance'
    else
      true
    end
  end

  def sort
    if @gamelist == []
      puts 'Game list is empty'
    else
      @gamelist.sort! { |a, b| a.name.downcase <=> b.name.downcase }
    end
  end

  def rate_game(data)
    if data[:game].is_a? Game
      if (0..5).include? data[:rating]
        data[:game].rate(user: self, rating: data[:rating])
      else
        puts 'your rating is not in valid range'
      end
    else
      puts 'this is not a game'
    end
  end
  
  def comment_game(data)
    data[:game].comment_count += 1
    data[:game].comments.push(Comment.new(user: self, text: data[:text],
	                                      id: data[:game].comment_count))
  end
  
  def send_message(data)
    data[:receiver].message_id += 1
    data[:receiver].messages.push(Message.new(sender: self,
                                              receiver: data[:receiver],
                                              text: data[:text],
                                              topic: data[:topic],
                                              id: data[:receiver].message_id))
  end

  def check_username(name)
    return @username == name
  end
  
  def check_data(name, password)
    return @username == name && @password == password
  end
end
