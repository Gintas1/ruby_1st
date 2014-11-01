require 'rspec'
require 'spec_helper'
require 'message'

describe Message do
  describe '#initialize' do
    it 'checks if new message is not read' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.read).to be false
    end
    it 'checks if new message has a topic named topic' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.topic).to eq('topic')
    end
    it 'checks if new message has a sender' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.sender).to eq(sender)
    end
    it 'checks if new message has a receiver' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.receiver).to eq(receiver)
    end
    it 'checks if new message has a date when it was sent' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.date).to be_a(Time)
    end
    it 'checks if new message has a text' do
      receiver = User.new(username: 'test', password: 'test')
      sender = User.new(username: 'test', password: 'test')
      message = Message.new(topic: 'topic', text: 'text', sender: sender,
                          receiver: receiver)
      expect(message.text).to eq('text')
    end
  end
end