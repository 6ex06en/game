require_relative "faye_websocket/connection"
require_relative "faye_websocket/eventer"
require_relative "faye_websocket/message_handler"

module FayeWebsocket

  def self.accept(ws, user)
    Eventer.handle ws, user
  end

end
