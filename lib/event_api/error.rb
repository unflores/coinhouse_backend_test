class EventApi::Error < StandardError
  attr_reader :message, :status

  def initialize(msg, status)
    @message = msg
    @status = status

    super(msg)
  end
end
