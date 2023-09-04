class MessageChannel < ApplicationCable::Channel
  def subscribed
    user = params['username']
    stream_from 'public_chat'
    ActionCable.server.broadcast 'public_chat', "#{user} joined!"
  end

  def receive(data)
    # Handle data received from the client
    ActionCable.server.broadcast 'public_chat', "#{data['message']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def broadcast_message(data)
    # Broadcast the message to all subscribed clients
    ActionCable.server.broadcast("MessageChannel", data)
  end
end
