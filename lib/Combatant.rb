class Combatant
    attr_accessor :name #TEMPORARY, REMOVE EVENTUALLY
    attr_accessor :current_HP, :max_HP
    attr_reader :atk, :defense, :atk_multi, :def_multi

    def initialize(attack,defense=0,max_HP)
        @name = "Slime" #TEMPORARY, REMOVE THIS LINE EVENTUALLY
        @atk = attack
        @defense = defense
        @max_HP = max_HP
        @current_HP = max_HP
        reset_buffs
    end

    def alive?
        if @current_HP <= 0
            false
        else
            true
        end
    end

    def reset_buffs
        @atk_multi = 1
        @def_multi = 1
    end
    #when a method is called that affects the current HP then change that attribute

    #when a character dies, remove from party
end
