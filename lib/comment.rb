#class for game comments
class Comment 
attr_accessor :time, :text, :user
  def initialize(data)
    @time = Time.now
	@text = data[:text]
	@user = data[:user]
  end
end