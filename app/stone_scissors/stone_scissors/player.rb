module StoneScissors
  class Player

    attr_reader :roll, :hint, :object 

    def initialize(object)
      @hint = false
      @object = object
    end

    def choose_figure!(figure)
      @roll = Core::Figures[figure]
    end

    def id
      object.id
    end
    
    protected
    
    def hint!
      @hint = true
    end

    def off_hint
      @hint = false
    end

    def clean_figure
      @figure = nil
    end

  end
end
