class MessageChannel < ApplicationCable::Channel
  def subscribed
    user = params['username']
    stream_from "private_chat_#{user}"
    # ActionCable.server.broadcast "private_chat_#{user}", "#{user} joined!"
  end

  def receive(data)
    # Handle data received from the client
    ActionCable.server.broadcast "private_chat_#{params['username']}", "#{data['message']}"
    # ActionCable.server.broadcast 'private_chat_', "#{params['username']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def broadcast_message(data)
  #   # Broadcast the message to all subscribed clients
  #   # ActionCable.server.broadcast('private_chat_2', data)
  # end
end
