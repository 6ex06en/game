require_relative "stone_scissors/connection"
require_relative "stone_scissors/core"
require_relative "stone_scissors/player"

module StoneScissors

  class << self

    def add_connection(ws, object)
      Connection.new(ws, object) unless Connection.find_by_player_id(object.id)
    end

    def new_game(object1_id, object2_id)
      con1 = Connection.find_by_player_id(object1_id)
      con2 = Connection.find_by_player_id(object2_id)
      if con1 && con2
        Core.new(con1.player, con2.player)
      else
        p "For game need two players"
      end
    end
  end

end

# con1 = StoneScissors.add_connection("fake_ws", User.first)
# con2 = StoneScissors.add_connection("fake_ws", User.second)
# p1 = StoneScissors::Connection.find_by_player_id(con1.player.id)
# p2 = StoneScissors::Connection.find_by_player_id(con2.player.id)
# StoneScissors.new_game(con1.player.id, con2.player.id)