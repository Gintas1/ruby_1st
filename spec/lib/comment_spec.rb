require 'rspec'
require 'spec_helper'
require 'comment'

describe Comment do
  describe '#initialize' do
    it 'checks text of a comment' do
      comment = Comment.New(text: 'text test', user: User.new(username: 'test', password: 'test'), )
      expect(comment.text).to eq('text test')
	end
    it 'checks author of a comment' do
      comment = Comment.New(text: 'text test', user: User.new(username: 'test', password: 'test'), )
      expect(comment.user.name).to eq('test')
	end
    it 'checks time of a comment' do
      comment = Comment.New(text: 'text test', user: User.new(username: 'test', password: 'test'), )
      expect(comment.time).to be(Time)
	end
  end
end