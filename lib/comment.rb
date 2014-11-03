# class for game comments
class Comment
  attr_accessor :time, :text, :user, :id
  def initialize(data)
    @time = Time.now
    @id = data[:id]
    @text = data[:text]
    @user = data[:user]
  end
end
