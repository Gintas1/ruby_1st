require 'rspec'
require 'spec_helper'
require 'purchase'

describe Purchase do
  describe '#initialize' do
    it 'checks the time' do
      purchase = Purchase.new(items: [Game.new(name: 'Game name test',
                                               genre: 'Genre test',
                                               description: 'desc test',
                                               price: 10)], price: 10) 
      expect(purchase.time).to be_a(Time)
    end
    it 'checks the time' do
      purchase = Purchase.new(items: [Game.new(name: 'Game name test',
                                               genre: 'Genre test',
                                               description: 'desc test',
                                               price: 10)], price: 10) 
      expect(purchase.price).to eq(10)
    end
    it 'checks the time' do
      purchase = Purchase.new(items: [Game.new(name: 'Game name test',
                                               genre: 'Genre test',
                                               description: 'desc test',
                                               price: 10)], price: 10) 
      expect(purchase.items).not_to be_empty
    end
  end
end