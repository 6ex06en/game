require_relative "player"

module StoneScissors
  class Connection

    class << self

      def connected
        @connected ||= []
      end
      
      def find_by_player_id(player_id)
        connected.find{|c| c.player.id == player_id}
      end
      
    end

    attr_reader :ws, :player

    def initialize(ws, object)
      @ws = ws
      @player ||= Player.new(object)
      Connection.connected << self
    end
    
  end

end
