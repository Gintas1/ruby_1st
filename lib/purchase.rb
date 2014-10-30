#class for user purchase
class Purchase
  attr_accessor :time, :items, :price
  def initialize(data)
    @time = Time.now
	@items = data[:items]
	@price = data[:price]
  end

end