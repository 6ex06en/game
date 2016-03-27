module FayeWebsocket

  def self.accept(ws, user)
    Eventer.handle ws, user
  end

end
