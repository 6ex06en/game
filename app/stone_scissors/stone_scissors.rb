require_relative "stone_scissors/connection"
require_relative "stone_scissors/core"
require_relative "stone_scissors/player"

module StoneScissors

  class << self

    def add_connection(ws, object)
      Connection.new(ws, object) unless Connection.find_by_player_id(object.id)
    end

    def new_game(connection1, connection2, timer = 10, max_score = 3)
      p1 = Player.new connection1.ws, connection1.user
      p2 = Player.new connection2.ws, connection2.user
      # p "start_game"
      Core.new(p1, p2, timer, max_score)
      FayeWebsocket::Connection.notify({game: "run_game"}, [p1.id, p2.id])
      # con1 = Connection.find_by_user_id(object1_id)
      # con2 = Connection.find_by_user_id(object2_id)
      # if con1 && con2
        # Core.new(con1.player, con2.player)
      # else
      #   p "For game need two players"
      # end
    end
  end

end

# con1 = StoneScissors.add_connection("fake_ws", User.first)
# con2 = StoneScissors.add_connection("fake_ws", User.second)
# p1 = StoneScissors::Connection.find_by_player_id(con1.player.id)
# p2 = StoneScissors::Connection.find_by_player_id(con2.player.id)
# StoneScissors.new_game(con1.player.id, con2.player.id)
