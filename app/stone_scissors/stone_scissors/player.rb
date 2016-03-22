module StoneScissors
  class Player

    class << self

      def find_player(plyer_name)
        Connection.connected.find{|c| c.player.user.name == player2_name}
      end
    end

    attr_reader :roll, :hint, :user 

    def initialize(user)
      @hint = false
    end

    def choose_figure!(figure)
      @figure = Game::Figures[figure]
    end

    def get_hint
      @hint = true if @hint == "used"
    end

    protected

    def off_hint
      @hint = "used"
    end

    def clean_figure
      @figure = nil
    end

    # private
    #
    # def valid_figure(figure)
    #   Game::Figures[figure] || nil
    # end

  end
end
