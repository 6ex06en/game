require_relative "stone_scissors/connection"
require_relative "stone_scissors/core"
require_relative "stone_scissors/player"

module StoneScissors

  class << self

    def new_game(connection1, connection2, timer = 10, max_score = 3)
      p1 = Player.new connection1.ws, connection1.user
      p2 = Player.new connection2.ws, connection2.user
      Core.new(p1, p2, timer, max_score)
    end
  end

end
