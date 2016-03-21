# require_relative "stone_scissors_paper/connection.rb"
# require_relative "stone_scissors_paper/core.rb"
# require_relative "stone_scissors_paper/player.rb"

module StoneScissors

  class << self

    def add_user(user)
      Player.new(user)
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
