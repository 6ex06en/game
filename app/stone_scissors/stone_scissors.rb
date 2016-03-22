require_relative "stone_scissors/connection"
require_relative "stone_scissors/core"
require_relative "stone_scissors/player"

module StoneScissors

  class << self

    def add_user(ws, user)
      Connection.new(ws, user)
    end

    def new_game(player1_name, player2_name)
      player1 = Player.find_player(player1_name)
      player2 = Player.find_player(player2_name)
      if player1 && player2
        Core.new(player1, player2)
      else
        p "For game need two players"
      end
    end
  end

end
