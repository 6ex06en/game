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
      # send_message({type: "game", game: "run_game"}.to_json)
      set_timer(time)
    end

    def set_timer(time)
      @timer = Thread.new do
        sleep time
        time_expired
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

    def resume_game
      disable_timer if timer_running?
      handle_rolls result(player1.roll, player2.roll)
    end

    # def check_status
    # end
    
    # def score
    # end
    
    def get_event(data)
      case data['game']
        when "roll"
          player = (data['sender'].to_i == player1.id) ? player1 : player2
          player.choose_figure! data['figure']
      end
    end

    def handle_rolls(result)
      message = ''
      if player1.roll == player2.roll
        message = build_message("drow")       
      else
        winner = if result == player1.roll 
          p1_score += 1
          player1
        else
          p2_score += 1
          player2
        end
        message = build_message("finish_round", {"winner" => winner.id}) 
        reset_rolls
      end
      # send_message(message)
    end

    def time_expired
      if player1.roll && player2.roll
        handle_rolls result(player1.roll, player2.rolll)
      else
        self.p1_score += 1 if player1.roll
        self.p2_score += 1 if player2.roll
        message = build_message("timeout")
        reset_rolls
        # send_message(message)
      end
    end
    
    def build_message(event, options = {})
      message = {
        "type"          => "game",
        "game"          => "#{event.to_s}",
        "#{player1.id}" => {"score" => p1_score}, 
        "#{player2.id}" => {"score" => p2_score}
      }
      case event
        when "timeout", "drow"
          [player1.id, player2.id].each do |id|
            player = (id == player1.id) ? player1 : player2
            message[id].merge({"figure" => player.roll})
          end
        when "finish_round"
          message.merge(options)
      end
      message   
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
      }
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
      [player1, player2].each{|p| p.ws.send(data.to_json)}
    end
  end
end
