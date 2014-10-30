# class for user
class User
  attr_accessor :username, :password, :balance,
                :cart, :gamelist, :purchases,
                :blocked
  def initialize(data)
    @username = data[:username]
    @password = data[:password]
    @balance = 0
    @cart = Cart.new
    @gamelist = []
    @purchases = []
	@blocked = false
	
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
      fail TypeError, 'item should be instance of a game'
    end
  end

  def clear_cart
    @cart.price = 0
    @cart.itemlist = []
  end

  def remove_from_cart(item)
    if item.is_a?(Game)
      if cart.itemlist.include? item
        @cart.price -= item.price * @cart.itemlist[item]
        @cart.itemlist.delete(item)
      else
        fail StandartError, 'item you want to remove is not in a list'
      end
    else
      fail TypeError, 'item instance is not a type of a Game'
    end
  end

  def buy
    return unless check_cart && check_balance
    @balance -= cart.price
    cart.itemlist.each { |x,y| y.times{@gamelist.push(x)} }
    @purchases.push(Purchase.new(price:cart.price, items: cart.itemlist.dup))
    clear_cart
    sort
  end

  def check_cart
    if @cart.itemlist.empty?
      fail StandartError, 'your cart is empty'
    else
      true
    end
  end

  def check_balance
    if @cart.price > @balance
      fail StandartError, 'insufficient balance'
    else
      true
    end
  end

  def sort
    if @gamelist == []
      fail StandartError, 'Game list is empty'
    else
      @gamelist.sort! { |a, b| a.name.downcase <=> b.name.downcase }
    end
  end

  def rate_game(data)
    if data[:game].is_a? Game
      if (0..5).include? data[:rating]
        data[:game].rate(user: self, rating: data[:rating])
      else
        fail StandartError, 'your rating is not in valid range'
      end
    else
      fail TypeError, 'this is not a game'
    end
  end
  
  def comment_game(data)
    data[:game].comments.push(Comment.new(user: self, text: data[:text]))
  end
end
