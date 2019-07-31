module Combatant
    attr_accessor :current_HP, :atk_multi, :def_multi, :stunned

    def alive?
        if @current_HP <= 0
            false
        else
            true
        end
    end

    def get_ready_for_combat   
        current_HP = max_HP
        self.reset_buffs
    end

    def reset_buffs
        @atk_multi = 1
        @def_multi = 1
    end
    #when a method is called that affects the current HP then change that attribute

    #when a character dies, remove from party
end
