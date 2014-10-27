require 'rspec'
require 'spec_helper'
require 'cart'

describe Cart do
  describe '#initialize' do
    it 'sets new cart' do
      cart = Cart.new
      expect(cart.price).to eq(0)
      expect(cart.itemlist).to match_array([])
    end
  end
end
