class Adventurer < ActiveRecord::Base
    attr_accessor :current_MP

    include Combatant
    def manual_generation(attack=4,defense=0,max_HP=10)
        hero = Adventurer.new
        hero.atk = attack
        hero.defense = defense
        hero.max_HP = max_HP
        hero.name = "Hero"
        hero.job = "none"
        hero.max_MP = 0
        hero.current_MP = 0
        hero.current_HP = hero.max_HP
        return hero
    end

    def generate_new_adventurer_with_job
        
    end

end