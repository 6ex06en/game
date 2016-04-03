require "timeout"
require "json"

module StoneScissors
  class Core
    Figures = {
      "stone" => :stone,
      "lizard" => :lizard,
      "scissors" => :scissors,
      "paper" => :paper,
      "spok" => :spok
    }

    attr_reader :player1, :player2, :time, :max_score
    attr_accessor :p1_score, :p2_score, :timer

    def initialize(creator, invited, time = 10, max_score = 3)
      @player1 = creator
      @player2 = invited
      @p1_score = 0
      @p2_score = 0
      @timer = timer
      @max_score = max_score
      @player1.game = @player2.game = self
      # send_message({type: "game", game: "run_game"}.to_json)
      wait_roll
    end

    # def wait_roll
    #   p "#{Thread.list.length}  - from wait_roll"
    #   Thread.new do
    #     # p "Strt_thread"
    #     until best_score == max_score
    #       begin
    #         # p "#{best_score} - best_score"
    #         Timeout.timeout(time) do
    #           loop do
    #             # p "start_loop"
    #             # sleep 1
    #             [player1, player2].each do |p|
    #               if p.hint
    #                 send_hint(p)
    #                 p.off_hint
    #               end
    #             end
    #             # p "no hint"
    #             if player1.roll && player2.roll
    #               puts("break loop")
    #               break
    #             end
    #           end
    #         end
    #       # rescue Timeout::Error
    #       rescue
    #         p "Trigger timeout"
    #         #p1_roll = player1.role #игнорировать изменение переменных,
    #         #p2_roll = player2.role #если присваивание произойдет после таймаута
    #         player_rolls = [player1, player2].map{|p| p.roll ? p.roll.to_s.dup : nil}
    #         p player_rolls
    #         time_expired(*player_rolls)
    #       end
    #       handle_rolls result(player1.roll, player2.roll)
    #     end
    #   end
    # end

    def wait_roll
      set_timer(time)
    end

    def set_timer(time)
      @timer = Thread.new do
        sleep time
        check_status
      end
    end

    def timer_running?
      @timer.is_a?(Thread) && @timer.alive?
    end

    def disable_timer
      @timer.kill
      @timer.join
      @timer = nil
    end

    def check_status
    end

    def score
    end

    def handle_rolls(result)
      player1.roll == result ? self.p1_score += 1 : self.p2_score += 1

      message = {
        "type" => "game",
        "game" => "win",
        "win_figure" => result,
        "#{player1.id}" => {"figure" => player1.roll, "score" => p1_score},
        "#{player2.id}" => {"figure" => player2.roll, "score" => p2_score}
      }.to_json
      reset_rolls
      send_message(message)
    end

    def time_expired(p1_roll, p2_roll)
      if p1_roll && p2_roll
        handle_rolls result(p1.roll, p2.roll)
      else
        self.p1_score += 1 if p1_roll
        self.p2_score += 1 if p2_roll
        message = {
          "type" => "game",
          "game" => "timeout",
          "creator" => {"score" => p1_score, "figure" => p1_roll},
          "guest" => {"score" => p2_score, "figure" => p2_roll}
        }.to_json
        reset_rolls
        send_message(message)
      end
    end

    def result(figures)
      case figures.sort
        when [:paper, :stone]     then :paper
        when [:scissors, :stone ] then :stone
        when [:lizard, :stone ]   then :stone
        when [:spok, :stone]      then :spok
        when [:paper, :scissors]  then :scissors
        when [:lizard, :paper]    then :lizard
        when [:paper, :spok]      then :paper
        when [:lizard, :scissors] then :scissors
        when [:scissors, :spok]   then :spok
        when [:lizard, :spok]     then :lizard
      end
    end

    def send_hint(player)
      competitor = player.competitor
      hint = Game::Figures.values - [competitor.roll] if competitor.roll
      message = {
        "type" => "game",
        "game" => "hint",
        "player" => (player == player1 ? "creator" : "guest"),
        "figure" => (hint ? [hint.sample, competitor.roll].shuffle : ["none"])
      }.to_json
      Connection.find_by_player_id(player.id).ws.send(message)
    end

    def best_score
      p1_score > p2_score ? p1_score : p2_score
    end

    def reset_rolls
      begin
        [player1, player2].each{|p| p.clean_figure}
      rescue => e
        raise e
      end
    end

    def send_message(data)
      p "send message"
      [player1, player2].each{|p| p.ws.send(data)}
    end
  end
end
