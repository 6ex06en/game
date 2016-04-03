class MainController < ApplicationController

  KEEPALIVE_TIME = 15

  def index
    @lobbies = Lobby.all
  end

  def ws
    if Faye::WebSocket.websocket?(request.env) && current_user
      ws = Faye::WebSocket.new(request.env, nil, {ping: KEEPALIVE_TIME})
      FayeWebsocket.accept(ws, current_user)
      # render :nothing
      head :ok
    else
      redirect_to root_path
    end
  end

end
