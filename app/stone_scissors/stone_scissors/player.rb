module StoneScissors
  class Player

    attr_reader :roll, :hint, :object, :ws
    attr_accessor :game

    def initialize(ws, object)
      @hint = false
      @object = object
      @ws = ws
    end

    def choose_figure!(figure)
      @roll = Core::Figures[figure]
      moved_piace
    end

    def id
      object.id
    end

    def clean_figure
      @roll = nil
    end

    def competitor
      game.player1 == self ? game.player2 : game.player1 if game
    end

    protected

    def moved_piace #сделан ход
      @game.resume_game if competitor.roll
    end

    def use_hint!
      @hint = true
    end

    def off_hint
      @hint = false
    end


  end
end
