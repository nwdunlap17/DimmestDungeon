class CombatManager
    attr_accessor :heroes_position, :monsters_position, :combat_is_over, :heroes_alive, :monsters_alive, :heroes_aggro

    def initialize(party,monsters_array,textlog,depth)
        #index 1-2 are front, 3-4 back
        #each array position should contain an object instance of representative thing
        @text_log = textlog
        @depth = depth
        @combat_is_over = false
        @heroes_alive = true
        @party = party
        @monsters_alive = true
        @heroes_position = party.heroes_array
        @monsters_position = monsters_array
        @heroes_aggro = []
        set_up_aggro(2)
        battle_sequence
    end

    def battle_sequence
        @heroes_position.each do |hero|
            hero.reset_buffs
        end
        @monsters_position.each do |monster|
            @text_log.write("A #{monster.name} appeared!")
        end
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
                    if monster.is_boss
                        battle_array << monster
                    end
                end
            end

            character_picked = battle_array.sample
    
            display(character_picked)
            if character_picked.stunned && (rand(2) == 0)
                character_picked.stunned = false
                @text_log.write("#{character_picked.name} was too stunned to move!")
            else
                if heroes_position.include?(character_picked)
                    chosen_action = choose_action_for_character(character_picked)
                    # binding.pry
                    select_target(character_picked, chosen_action,monsters_position,heroes_position)
                    #select_target(character_picked,Action.basic_attack,monsters_position,heroes_position)
                else
                    #monster
                    monsters_target = @heroes_aggro.sample
                    execute_action(character_picked,Action.basic_attack,[monsters_target],[])
                end
            end
            battle_array.delete(character_picked)
            self.check_for_dead
        end
        if heroes_alive == false
            counter = 5
            5.times do
                    Curses.clear
                Curses.setpos(10,10)
                Curses.addstr"Your party has died. GAME OVER. Game will automatically exit in 5 seconds. Game terminating in #{counter}."
                Curses.refresh
                counter -= 1
                sleep(1)
            end
            exit
        end
    end


    def choose_action_for_character(adventurer)
        choices = []
        choices << Action.basic_attack
        choices << adventurer.skill1
        choices << adventurer.skill2
        names_of_choices = []
        description_of_choices = []
        #binding.pry
        if @party.potions > 0
            choices << Action.use_potion
        end
        if @party.elixirs > 0
            choices << Action.use_elixir
        end
        choices.each do |action|
            names_of_choices << action.action_name
            description_of_choices << action.description
        end
        choices.length.times do |index|
            if adventurer.current_MP < choices[index].mp_cost
                choices[index] = nil
                description_of_choices[index] += " NOT ENOUGH MP"
            end
            if choices[index].action_name == "Potion"
                description_of_choices[index] += "#{@party.potions}."
            elsif choices[index].action_name == "Elixir"
                description_of_choices[index] += "#{@party.elixirs}."
            end
        end
        return Menu.start(names_of_choices,choices,Curses.lines-6,1,description_of_choices)
    end

    def display(character_picked)
        Curses.clear
        @party.standard_menu_display
        display_adventurers(character_picked)
        @monsters_position.length.times do  |index|
            stun_symbol = " "
            if @monsters_position[index].stunned
                stun_symbol = "@"
            end
            Curses.setpos(index,9)
            Curses.addstr " " + stun_symbol + "#{monsters_position[index].name}" + "  HP: #{monsters_position[index].current_HP} / #{monsters_position[index].max_HP}"
            
        end
        display_monsters()
        @text_log.display_text
        Curses.setpos(0,76)
        Curses.addstr "Depth: #{@depth}"
        Curses.refresh
    end


    def display_monsters
        top = 7
        left = 10
        midleft = 30
        cenleft = 37
        mid = 50
        cenright = 63
        midright = 70
        right = 90
        case @monsters_position.length
        when 1
            draw_monster(monster_art(),top,mid)
        when 2
            draw_monster(monster_art(),top,midleft)
            draw_monster(monster_art(),top,midright)
        when 3
            draw_monster(monster_art(),top,left)
            draw_monster(monster_art(),top,mid)
            draw_monster(monster_art(),top,right)
        when 4
            draw_monster(monster_art(),top,left)
            draw_monster(monster_art(),top,cenleft)
            draw_monster(monster_art(),top,cenright)
            draw_monster(monster_art(),top,right)
        end
    end

    def draw_monster(monster_string,y,x)
        monster_string.length.times do |counter|
            Curses.setpos(y+counter,x)
            Curses.addstr(monster_string[counter])
        end
    end 

    def monster_art
        return ["    _______     ","   /  ___  \\    ","  / /#####\\ \\   "," | |#######| |  ","  \\_\\#####/_/   "," |\\ /      \\    "," || |    |==+==|"," || |    |+=+=+|","<||>|    |+=+=+|"," () |     \\___/ ","    |_______|   ","    |_|   |_|   "]
    end 

    def display_adventurers(character_picked)

        start_display_line = Curses.lines-4
        @heroes_position.length.times do  |index|
            if character_picked == @heroes_position[index]
                Curses.setpos(start_display_line+index,19)
                Curses.addstr ">"
            end
        end
    end

    def set_up_aggro(starting_aggro)
        starting_aggro.times do
            @heroes_position.each do |hero|
                @heroes_aggro << hero
            end
        end
        @heroes_position.each do |hero|
            if hero.job == "Fighter"
                @heroes_aggro << hero
            end
        end
    end

    def change_aggro(character,change_value)
        new_aggro = @heroes_aggro.count(character)
        if (new_aggro + change_value) > 0
            new_aggro = new_aggro + change_value
            @heroes_aggro.delete(character)
            new_aggro.times do
                @heroes_aggro << character
            end
        else
            @text_log.write("#{character.name} is already as hidden as possible!")
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
                eulogy_quotes = ["May they rest in peace.","Who will be next, I wonder?","From dust, to dust."]
                @text_log.write("#{hero.name} has died. #{eulogy_quotes.sample}")
                heroes_position.delete(hero)
                heroes_aggro.delete(hero)
                hero.delete
                if heroes_position.empty? == true
                    @heroes_alive = false
                    @combat_is_over = true
                end
            end
        end
        index = 0
        while index < self.monsters_position.length
            if monsters_position[index].alive? == false
                @text_log.write("#{monsters_position[index].name} has been slain.")
                monsters_position.delete_at(index)
                index = 0
                if monsters_position.empty? == true
                    @monsters_alive = false
                    @combat_is_over = true
                end
            end
            index += 1
        end
    end


        #invisibility pulls one aggro
        #increase aggro adds two aggro
        #heroes_aggro.sample = defender

        # actor is Combatant
    # action is used Action
    # defenders and allied_targets are arrays of Combatants
    def execute_action(actor,action,damage_targets,buff_targets)
        @text_log.write("#{actor.name} used #{action.action_name}.")
        if action.mp_cost > 0
            actor.current_MP -= action.mp_cost
        end
        if action.action_name == "Potion"
            @party.potions -= 1
        elsif action.action_name == "Elixir"
            @party.elixirs -= 1
        end
        damage_targets.each do |target|
            deal_damage(actor,target,action)
            if action.stun_chance > 0
                if rand(10) < (action.stun_chance*10)
                    target.stunned = true
                    @text_log.write("#{target.name} is dizzy!")
                end
            end
        end
        buff_targets.each do |target|
            apply_buff(target,action)
            if (action.aggro_change != 0)
                change_aggro(target,action.aggro_change)
            end
        end
    end

 def deal_damage(attacker,defender,action)
    attack_power = attacker.atk * attacker.atk_multi * action.damage_multiplier
    defense_power = defender.defense * defender.def_multi
    damage_dealt = (attack_power * 4) - (defense_power * 2)
    damage_dealt = damage_dealt.round
    if damage_dealt < 1
        damage_dealt = 1
    end
    defender.current_HP -= damage_dealt
    @text_log.write("#{defender.name} took #{damage_dealt} damage!")
 end

 def apply_buff(target, action)
    target.atk_multi += action.atk_buff
    target.def_multi += action.def_buff
    heal_amount = (target.max_HP * action.heal_value).round
    target.current_HP += heal_amount
    restore_amount = (target.max_MP * action.mp_restore).round
    target.current_MP += restore_amount
    if target.current_HP > target.max_HP
        heal_amount -= (target.current_HP - target.max_HP)
        target.current_HP = target.max_HP
    end
    if target.current_MP > target.max_MP
        restore_amount -= (target.current_MP - target.max_MP)
        target.current_MP = target.max_MP
    end
    if action.atk_buff > 0
        @text_log.write("#{target.name}'s ATK has improved.")
    end
    if action.def_buff > 0
        @text_log.write("#{target.name}'s DEF has improved.")
    end
    if heal_amount > 0
        @text_log.write("#{target.name} has healed #{heal_amount} HP.")
    end
    if restore_amount > 0
        @text_log.write("#{target.name} has restored #{restore_amount} MP.")
    end
 end

 def select_target(actor, action, enemy_array, ally_array)
    enemy_targets = []
    enemy_descriptions = []
    enemy_array.each do |monster|
        enemy_descriptions << monster.description
    end
    ally_targets = []
    if action.target_self
        ally_targets << actor
    end
    case action.selection_type
    when "none"
    when "All Enemies"
        enemy_targets = enemy_array
    when "All Allies"
        ally_targets = ally_array
    when "1 Enemy"
        enemy_names = enemy_array.map {|foe| foe.name}
        enemy_targets << Menu.start(enemy_names,enemy_array,0,7,enemy_descriptions)
    when "1 Ally"
        ally_names = ally_array.map {|ally| ally.name}
        ally_targets << Menu.start(ally_names,ally_array,Curses.lines-11,0)
    end
    execute_action(actor,action,enemy_targets,ally_targets)
 end

end