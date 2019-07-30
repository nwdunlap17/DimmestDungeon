class CombatManager
    attr_accessor :heroes_position, :monsters_position, :combat_is_over, :heroes_alive, :monsters_alive, :heroes_aggro

    def initialize(heroes_array,monsters_array)
        #index 1-2 are front, 3-4 back
        #each array position should contain an object instance of representative thing
    @combat_is_over = false
    @heroes_alive = true
    @monsters_alive = true
    @heroes_position = heroes_array
    @monsters_position = monsters_array
    @heroes_aggro = []
    battle_sequence
    end

    def battle_sequence
        battle_array = []
        while @combat_is_over == false

            #Refresh initiative order
            if battle_array.empty? == true
                battle_array = []
                heroes_position.each do |hero|
                    battle_array << hero
                end
                monsters_position.each do |monster|
                    battle_array << monster
                end
            end

            character_picked = battle_array.sample
    
            display(character_picked)
            if heroes_position.include?(character_picked)
                select_target(character_picked, Action.basic_attack,monsters_position,heroes_position)
            else
                #monster
            end

            battle_array.delete(character_picked)
            self.check_for_dead
        end
        if heroes_alive == false
            #end game method
        elsif monsters_alive == false
            #YEET we won
        end
    end

    def display(character_picked)
        Curses.clear
        Curses.setpos(0,0)
        @monsters_position.length.times do  |index|
            Curses.addstr " #{monsters_position[index].name} HP: #{monsters_position[index].current_HP} / #{monsters_position[index].max_HP} \n"
        end
        start_display_line = 5
        @heroes_position.length.times do  |index|
            Curses.setpos(start_display_line+index,0)
            Curses.addstr " #{heroes_position[index].name} HP: #{heroes_position[index].current_HP} / #{heroes_position[index].max_HP}"
            if character_picked == @heroes_position[index]
                Curses.setpos(start_display_line+index,0)
                Curses.addstr ">"
            end
        end
        Curses.refresh
    end

    def change_aggro(character,change_value)
        #change_value can be a positive or negative number
        #character = object, change_value = integer
        new_heroes = []
        if change_value > 0
            change_value.times do 
                @heroes_aggro << character
            end
        elsif change_value < 0
            if @heroes_aggro.count(character) > change_value.abs
                counter = change_value.abs
                while counter != 0
                    @heroes_aggro = @heroes_aggro.map do |hero|
                        if hero == character 
                            hero = nil
                            counter -= 1
                        else
                            hero
                        end
                    end.compact
                end
            end
        end
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
                    @combat_is_over = true
                end
            end
        end
        self.monsters_position.each do |monster|
            if monster.alive? == false
                monsters_position.delete(monster)
                if monsters_position.empty? == true
                    @monsters_alive = false
                    @combat_is_over = true
                end
            end
        end
    end


        #invisibility pulls one aggro
        #increase aggro adds two aggro
        #heroes_aggro.sample = defender

        # actor is Combatant
# action is used Action
# defenders and allied_targets are arrays of Combatants
def execute_action(actor,action,damage_targets,buff_targets)
    damage_targets.each do |target|
        deal_damage(actor,target,action)
    end
    buff_targets.each do |target|
        apply_buff(target,action)
        if (action.aggro_change != 0)
            change_aggro(target,action.aggro_change)
        end
    end
 end

 def deal_damage(attacker,defender,action)
    attack_power = attacker.atk * attacker.atk_multi
    defense_power = defender.defense * defender.def_multi
    damage_dealt = (attack_power * 4) - (defense_power * 2)
    damage_dealt = damage_dealt.round
    defender.current_HP -= damage_dealt
 end

 def apply_buff(target, action)
    target.atk_multi += action.atk_buff
    target.def_multi += action.def_buff
    target.current_HP += target.max_HP * action.heal_value
    target.current_HP.round
    if target.current_HP > target.max_HP
        target.current_HP = target.max_HP
    end
 end

 def select_target(actor, action, enemy_array, ally_array)
    enemy_targets = []
    ally_targets = []
    if action.target_self
        ally_targets << actor
    end
    case action.selection_type
    when "none"
    when "All Enemies"
        enemy_targets = enemy_array
    when "All Allies"
        allied_targets = ally_array
    when "1 Enemy"
        enemy_names = enemy_array.map {|foe| foe.name}
        enemy_targets << Menu.start(enemy_names,enemy_array,10,0)
    when "1 Ally"
        ally_names = ally_array.map {|ally| ally.name}
        ally_targets << Menu.start(enemy_names,enemy_array,10,0)
    end
    execute_action(actor,action,enemy_targets,ally_targets)
 end

end