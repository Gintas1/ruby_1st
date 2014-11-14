require 'yaml'

# class for user purchase
class Purchase
  attr_accessor :time, :items, :price, :buyer, :id

  class << self
    attr_accessor :sales, :sales_id
  end
  SALES_FILE_NAME = 'sales.yaml'
  begin
    @sales = YAML.load(File.read(SALES_FILE_NAME))
  rescue
    @sales = []
  end

  @sales_id = @sales.count > 0 ? @sales[@sales.count - 1].id : 0

  def self.load_from_file(fileame = SALES_FILE_NAME)
    @sales = YAML.load(File.read(fileame))
    @sales_id = @sales.count > 0 ? @sales[@sales.count - 1].id : 0
  end

  def self.clear_sales
    @sales = []
    @sales_id = 0
  end

  def self.sale_info
    @sales = YAML.load(File.read(SALES_FILE_NAME))
  end

  def initialize(data)
    self.class.sales_id += 1
    @buyer = data[:buyer]
    @time = Time.now
    @items = data[:items]
    @price = data[:price]
    @id = self.class.sales_id
    add_to_sales
  end

  def add_to_sales
    self.class.sales.push(self)
    Purchase.save_to_file
  end

  def self.save_to_file(filename = SALES_FILE_NAME)
    File.open filename, 'w' do |f|
      f.write YAML.dump(@sales)
    end
  end
end
