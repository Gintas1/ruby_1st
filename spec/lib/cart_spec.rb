require 'rspec'
require 'spec_helper'
require 'cart'

describe Cart do
  describe '#initialize' do
    it 'checks price of a new cart' do
      cart = Cart.new
      expect(cart.price).to eq(0)
    end
    it 'checks item list of a new cart' do
      cart = Cart.new
      expect(cart.itemlist).to be_empty
    end
  end
end
