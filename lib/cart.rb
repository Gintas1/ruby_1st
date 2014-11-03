# class for user cart
class Cart
  attr_accessor :price, :itemlist
  def initialize
    @itemlist = {}
    @price = 0
  end

  def clear
    @price = 0
    @itemlist = {}
  end
end
