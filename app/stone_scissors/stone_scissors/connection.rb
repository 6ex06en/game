module StoneScissors
  class Connection

    class << self

      def connected
        @connected ||= []
      end

    end

    attr_reader :ws, :user

    def initialize(ws, user)
      @ws = ws
      @user = Player.new(user)
      Connection.connected << self
    end

  end

end
