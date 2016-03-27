module StoneScissors
  class Player

    attr_reader :roll, :hint, :object, :ws

    def initialize(ws, object)
      @hint = false
      @object = object
      @ws = ws
    end

    def choose_figure!(figure)
      @roll = Core::Figures[figure]
    end

    def id
      object.id
    end

    def clean_figure
      @roll = nil
    end

    protected

    def hint!
      @hint = true
    end

    def off_hint
      @hint = false
    end


  end
end
