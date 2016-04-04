module FayeWebsocket
  class MessageHandler
    class << self
      
      def handle_message(ws, ws_data)
        connection = Connection.find_by_ws(ws)
        game = StoneScissors.find_by_player_id(ws_data["sender"])
        if connection && game
          game.get_event(ws_data) if valid_sender?(connection, ws_data)
        end
      end
      
      def valid_sender?(connection, ws_data)
        connection.user.id.to_i == ws_data["sender"].to_i
      end

    end
  end
end
