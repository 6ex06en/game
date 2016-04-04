require_relative "stone_scissors/connection"
require_relative "stone_scissors/core"
require_relative "stone_scissors/player"

module StoneScissors

  class << self
    
    def games
      @games ||= []
    end
    
    def new_game(connection1, connection2, timer = 10, max_score = 3)
      p1 = Player.new connection1
      p2 = Player.new connection2
      p "games - #{games}"
      @games << Core.new(p1, p2, timer, max_score)
      p "games - #{games}"
    end
    
    def find_by_player_id(id)
      games.find{|g| g.player1.id == id || g.playe2.id == id}
    end
  end

end
# con1 = FayeWebsocket::Connection.new("fake_ws", User.first)
# con2 = FayeWebsocket::Connection.new("fake_ws", User.second)
# p1 = StoneScissors::Player.new con1
# p2 = StoneScissors::Player.new con2
# game = StoneScissors::Core.new(p1,p2)