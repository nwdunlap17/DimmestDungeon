class Combatant
    attr_accessor :name #TEMPORARY, REMOVE EVENTUALLY
    attr_accessor :current_hp, :max_hp
    attr_reader :atk, :def, :atk_multi, :def_multi

    def initialize(attack,defense=0,max_hp)
        @name = "Slime" #TEMPORARY, REMOVE THIS LINE EVENTUALLY
        @atk = attack
        @def = defense
        @max_hp = max_hp
        @current_hp = max_hp
        reset_buffs
    end

    def alive?(character)
        if character.current_health <= 0
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