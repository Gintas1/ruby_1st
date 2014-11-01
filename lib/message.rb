#class for message 
class Message
  attr_accessor :read, :receiver, :sender, :date, :topic, :text 
  def initialize(data)
    @read = false
	@receiver = data[:receiver]
	@sender = data[:sender]
	@date = Time.now
	@topic = data[:topic]
	@text = data[:text]
  end

end
