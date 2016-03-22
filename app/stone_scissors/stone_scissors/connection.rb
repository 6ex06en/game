require_relative "player"

module StoneScissors
  class Connection

    class << self

      def connected
        @connected ||= []
      end

    end

    attr_reader :ws, :player

    def initialize(ws, user)
      @ws = ws
      @player ||= Player.new(user)
      Connection.connected << self
    end

  end

end
