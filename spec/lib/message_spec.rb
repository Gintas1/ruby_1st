require 'rspec'
require 'spec_helper'
require 'message'

describe Message do
  def '#initialize' do
    it 'checks if new message is not read' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.read).to be_a(false)
    end
    it 'checks if new message has a topic named topic' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.topic).to eq('topic')
    end
    it 'checks if new message has a sender' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.from).to eq(sender)
    end
    it 'checks if new message has a receiver' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.to).to eq(receiver)
    end
    it 'checks if new message has a date when it was sent' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.date).to be_a(Time)
    end
    it 'checks if new message has a text' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', from: sender,
                          to: receiver)
      expect(message.text).to eq('text')
    end
  end
end