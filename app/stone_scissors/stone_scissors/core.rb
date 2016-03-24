require "timeout"

module StoneScissors
  class Core
    Figures = {
      "stone" => :stone,
      "lizard" => :lizard,
      "scissors" => :scissors,
      "paper" => :paper,
      "spok" => :spok
    }

    attr_reader :palyer1, :player2, :timer, :max_score
    attr_accessor :p1_score, :p2_score

    def initialize(creator, invited, timer = 10, max_score = 3)
      @player1 = creator
      @player2 = invited
      @p1_score = 0
      @p2_score = 0
      @timer = timer
      # @current_plyer = nil
      @max_score = max_score
      wait_roll
    end

    def wait_roll
      Thread.new do
        p "Strt_thread"
        until best_score == max_score
          begin
            p "#{best_score} - best_score"
            #Timeout.timeout(timer) do
              loop do
                p "start_loop"
                sleep 1
                [player1, player2].each do |p|
                  send_hint(p); p.off_hint if p.hint
                end
                break if player1.roll && player2.roll
              end
            #end
          rescue Timeout::Error
            p "Trigger timeout"
            p1_roll = player1.role.dup #игнорировать изменение переменных,
            p2_roll = player2.role.dup #если присваивание произойдет после таймаута
            time_expired(p1_roll, p2_roll)
          end
          handle_rolls result(player1.roll, player2.roll)
        end
      end
    end

    def score
    end

    def handle_rolls(result)
      player1.roll == result ? @p1_score += 1 : @p2_score += 1

      message = {
        "game" => "win",
        "win_figure" => result,
        "#{player1.id}" => {"figure" => player1.roll, "score" => p1_score},
        "#{player2.id}" => {"figure" => player2.roll, "score" => p2_score}
      }
      clean_figure
      send_message(message)
    end

    def time_expired(p1_roll, p2_roll)
      if p1_roll && p2_roll
        handle_rolls result(p1.roll, p2.roll)
      else
        p1_score += 1 if p1_roll
        p2_score += 1 if p2_roll
        message = {
          "game" => "timeout",
          "#{player1.id}" => {"score" => p1_score, "figure" => p1_roll},
          "#{player2.id}" => {"score" => p2_score, "figure" => p2_roll}
        }
        clean_figure
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
      competitor = player == player1 ? player2 : player1
      hint = Game::Figures.values - [competitor.roll] if competitor.roll
      message = {
        "game" => "hint",
        "player" => player.id,
        "figure" => (hint ? [hint.sample, competitor.roll].shuffle : ["none"])
      }
      Connection.find_by_player_id(player.id).ws.send(message)
    end

    def best_score
      p1_score > p2_score ? p1_score : p2_score
    end

    def clean_figure
      [player1, player2].each{|p| p.clean_figure}
    end

    def send_message(data)
      [player1, player2].each{|p| p.ws.send(data)}
    end
  end
end
