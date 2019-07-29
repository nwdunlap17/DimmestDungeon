class Combatant
    attr_accessor :CURRENT_HP
    attr_reader :ATK, :DEF

    def initialize(attack,defense=0,max_hp)
        @ATK = attack
        @DEF = defense
        @MAX_HP = max_hp
        @CURRENT_HP = max_hp
    end

    def alive?(character)
        if character.current_health <= 0
            false
        else
            true
        end
    end

    #when a method is called that affects the current HP then change that attribute

    #when a character dies, remove from party
end
