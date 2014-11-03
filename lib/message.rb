# class for message
class Message
  attr_accessor :read, :receiver, :sender, :date, :topic, :text, :id
  def initialize(data)
    @read = false
    @receiver = data[:receiver]
    @sender = data[:sender]
    @date = Time.now
    @topic = data[:topic]
    @text = data[:text]
    @id = data[:id]
  end
end
