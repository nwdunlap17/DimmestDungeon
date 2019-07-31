class Adventurer < ActiveRecord::Base
    attr_accessor :current_MP

    include Combatant
    def self.manual_generation(name = "Hero",attack=4,defense=0,max_HP=10)
        hero = Adventurer.new
        hero.atk = attack
        hero.defense = defense
        hero.max_HP = max_HP
        hero.name = name
        hero.job = "none"
        hero.max_MP = 0
        hero.current_MP = 0
        hero.current_HP = hero.max_HP
        hero.reset_buffs
        return hero
    end

    def generate_new_adventurer_with_job
        
    end

end