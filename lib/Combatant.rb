module Combatant
    attr_accessor :current_HP, :max_HP, :stunned
    attr_accessor :atk, :defense, :atk_multi, :def_multi

    def initialize(attack=4,defense=0,max_HP=10)
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
