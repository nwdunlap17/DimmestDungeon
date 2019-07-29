class CombatManager
    attr_accessor :heroes_position
    def initialize(heroes_array,monsters_array)
        #index 1-2 are front, 3-4 back
        #each array position should contain an object instance of representative thing
    @combat_is_over = false
    @heroes_alive = true
    @monsters_alive = true
    @heroes_position = heroes_array
    @monsters_position = monsters_array
    heroes_aggro = []
    end

    def battle_sequence
        while @combat_is_over == false
            if battle_array.empty? == true
                heroes = heroes_position
                monsters = monsters_position
                battle_array = heroes.concat(monsters)
            end
            character_picked = battle_array.sample
            #some course of action 
            battle_array.delete(character_picked)
            self.check_for_dead
        end
        if heroes_alive == false
            #end game method
        elsif monsters_alive == false
            #YEET we won
        end
    end

    def add_aggro
    end

    def apply_damage(damaged_object,damage_dealt)
        #damaged_object = instance of monster or adventurer that is damaged
        #damage_dealt = some integer value of damage
        current_HP = damaged_object.current_health
        new_health = current_HP - damage_dealt
        damaged_object.current_health = new_health
    end

    def check_for_dead
        self.heroes_position.each do |hero|
            if hero.alive? == false
                heroes_position.delete(hero)
                heroes_aggro.delete(hero)
                if heroes_position.empty? == true
                    @heroes_alive = false
                    @combat_is_over == true
                end
            end
        end
        self.monsters_position.each do |monster|
            if monster.alive? == false
                monsters_position.delete(monster)
                if monsters_position.empty? == true
                    @monsters_alive = false
                    @combat_is_over == true
                end
            end
        end
    end
    

        #invisibility pulls one aggro
        #increase aggro adds two aggro
        #heroes_aggro.sample = defender


end