#class for user purchase
class Purchase
  attr_accessor :time, :items, :price, :buyer
  def initialize(data)
    @buyer = data[:buyer]
    @time = Time.now
    @items = data[:items]
    @price = data[:price]
  end

end