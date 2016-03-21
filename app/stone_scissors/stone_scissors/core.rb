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

    # def self.figures
    #   ["stone", "lizard", "scissors", "paper", "spok"]
    # end

    # def start
    #   if timer
    #     with_timer { rolls }
    #   else
    #     rolls
    #   end
    # end
    #
    # def rolls(first_player)
    #   wait_roll(player)
    # end

    # def next_player
    #   @current_plyer =  if @current_plyer == player1 : player2 : player1
    # end

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

    def wait_roll(player)
      Thread.new do
        until best_score == max_score
          begin
            Timeout.timeout(timer) do
              loop do
                [player1, player2].each do |p|
                  send_hint(p); p.off_hint if p.hint === true
                end
                break if player1.roll && player2.roll
              end
            end
          rescue Timeout::Error
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
        "#{player1.name}" => {"figure" => player1.roll, "score" => p1_score},
        "#{player2.name}" => {"figure" => player2.roll, "score" => p2_score}
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
          "#{player1.name}" => {"score" => p1_score, "figure" => p1_roll},
          "#{player2.name}" => {"score" => p2_score, "figure" => p2_roll}
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

    def send_hint(user)
      competitor = user == player1 ? player2 : player1
      hint = Game::Figures.values - [competitor.roll] if competitor.roll
      message = {
        "game" => "hint",
        "player" => "#{user.name}",
        "figure" => (hint ? [hint, competitor.roll].shuffle : ["none"])
      }
      user.ws.send(message)
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
