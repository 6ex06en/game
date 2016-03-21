class MainController < ApplicationController

  def index
  end

  def ws
    if Faye::Websocket.websocket(request.env)
      ws = Faye::Websocket.new(request.env)
    else
      render nothing: true
    end
  end

end
