require "json"

module FayeWebsocket
  class Connection

    class << self

      def connected
        @connected ||= []
      end

      def find_by_user_id(user_id)
        connected.find{|c| c.user.id == user_id}
      end
      
      def find_by_ws(ws)
        connected.find{|c| c.ws == ws}
      end

      def new(ws, user)
        connection = find_by_user_id(user.id)
        p "connection - #{connection}"
        if connection
          connection.ws = ws
        else
          super
        end
      end

      def notify(data, users_id)
          data.merge!({"type" => "notify"})
          connected.find_all{|c| [*users_id].include? c.user.id}
                       .each{|c| c.ws.send data.to_json }
      end
    end

    attr_accessor :ws, :user

    def initialize(ws, user)
      @ws = ws
      @user = user
      Connection.connected << self
    end

  end
end
