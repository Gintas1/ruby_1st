require 'rspec'
require 'spec_helper'
require 'comment'

describe Comment do
  describe '#initialize' do
    it 'checks text of a comment' do
      comment = Comment.new(text: 'text test',
                            user: User.new(username: 'test', password: 'test'),
                            id: 1)
      expect(comment.text).to eq('text test')
    end
    it 'checks author of a comment' do
      comment = Comment.new(text: 'text test',
                            user: User.new(username: 'test', password: 'test'),
                            id: 1)
      expect(comment.user.username).to eq('test')
    end
    it 'checks time of a comment' do
      comment = Comment.new(text: 'text test',
                            user: User.new(username: 'test', password: 'test'),
                            id: 1)
      expect(comment.time).to be_a(Time)
    end
    it 'checks time of a comment' do
      comment = Comment.new(text: 'text test',
                            user: User.new(username: 'test', password: 'test'),
                            id: 1)
      expect(comment.id).to eq(1)
    end
  end
end
