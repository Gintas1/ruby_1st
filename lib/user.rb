require 'yaml'
# class for user
class User
  attr_accessor :username, :password, :balance,
                :cart, :gamelist, :purchases,
                :blocked, :messages, :message_id, :id,
                :logged_in, :admin

  class << self
    attr_accessor :users, :user_id
  end

  USERS_FILE_NAME = 'users.yaml'

  begin
    @users = YAML.load(File.read(USERS_FILE_NAME))
  rescue
    @users = []
  end

  @user_id = @users.count > 0 ? @users[@users.count - 1].id : 0

  def self.clear
    @users = []
    @user_id = 0
    save_to_file
  end

  def self.load_from_file(filename = USERS_FILE_NAME)
    @users = YAML.load(File.read(filename))
    @user_id = @users.count > 0 ? @users[@users.count - 1].id : 0
  end

  def self.all_users
    @users = YAML.load(File.read(USERS_FILE_NAME))
  end

  def self.invalid_name?(name)
    @users.any? { |user| user.username.casecmp(name) == 0 } || name == ''
  end

  def self.register(name, password)
    return if invalid_name?(name)
    @user_id += 1
    User.new(username: name, password: password, id: @user_id)
  end

  def self.get_by_name(name)
    @users.find { |user| user.username.casecmp(name) == 0 }
  end

  def self.get_by_id(id)
    @users.find { |user| user.id == id }
  end

  def self.login(username, password)
    return if (user = get_by_name(username)).nil?
    if user.password == password && !user.blocked
      user.logged_in = true
      save_to_file
      user
    end
  end

  def self.save_to_file(filename = USERS_FILE_NAME)
    File.open filename, 'w' do |f|
      f.write YAML.dump(@users)
    end
  end

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
    @admin = @username.casecmp('gintas') == 0 ? true : false
    @logged_in = false
    @id = data[:id]
    add
  end

  def make_admin
    @admin = true
    self.class.save_to_file
  end

  def block
    @blocked = true
    self.class.save_to_file
  end

  def edit_balance(new_balance)
    @balance = new_balance
    self.class.save_to_file
  end

  def info
    [@id, @username, @balance, @blocked, @admin]
  end

  def unblock
    @blocked = false
    self.class.save_to_file
  end

  def add
    self.class.users.push(self)
    self.class.save_to_file
  end

  def delete
    self.class.users.delete(self)
    self.class.save_to_file
  end

  def add_to_cart(item_id, amount = 1)
    return unless !(item = Game.get_by_id(item_id)).nil? && amount > 0
    if cart.itemlist.include? item
      @cart.itemlist[item] += amount
      @cart.price += amount * item.price
    else
      @cart.itemlist[item] = amount
      @cart.price += amount * item.price
    end
    self.class.save_to_file
  end

  def clear_cart
    @cart.clear
    self.class.save_to_file
  end

  def remove_from_cart(item_id)
    item = @cart.itemlist.keys.find { |i| i.id == item_id }
    return if (item).nil?
    @cart.price -= item.price * @cart.itemlist[item]
    @cart.itemlist.delete(item)
    self.class.save_to_file
  end

  def buy
    return unless @cart.price <= @balance
    @balance -= cart.price
    cart.itemlist.each { |x, y| y.times { @gamelist.push(x.clone) } }
    @purchases.push(Purchase.new(price: cart.price, items: cart.itemlist.dup,
                                 buyer: self))
    clear_cart
    self.class.save_to_file
  end

  def sort
    @gamelist.sort! { |a, b| a.name.downcase <=> b.name.downcase }
    self.class.save_to_file
  end

  def send_message(receiver_id, topic, text)
    receiver = User.get_by_id(receiver_id)
    receiver.message_id += 1
    receiver.messages.push(Message.new(sender: self, receiver: receiver,
                                       text: text, topic: topic,
                                       id: receiver.message_id))
    self.class.save_to_file
  end
end
