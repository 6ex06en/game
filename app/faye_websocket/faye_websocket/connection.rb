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

      def new(ws, user)
        super unless find_by_user_id(user.id)
      end

      def notify(data, users_id)
          data.merge!({"type" => "notify"})
          connected.find_all{|c| [*users_id].include? c.user.id}
                       .each{|c| c.ws.send data.to_json }
      end
    end

    attr_reader :ws, :user

    def initialize(ws, user)
      @ws = ws
      @user = user
      Connection.connected << self
    end

  end
end
