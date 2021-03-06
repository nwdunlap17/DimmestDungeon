class ExplorationLoop
    attr_accessor :depth, :text_log, :party
    def initialize
        @text_log = Text_Log.new
        @party = Party.new
        @depth = 1
        select_room
    end

    def select_room
        @fork_instance = Fork.new(@depth)
        @text_log.write("Your party ventures into the dungeon, led by a #{@party.heroes_array[1].job} named #{@party.heroes_array[1].name}.")
        @text_log.write("Will you find glory or death in these dark halls?")
        while true
            choice_names = @fork_instance.room_labels 
            values = @fork_instance.rooms_in_fork
            descriptions = []
            @fork_instance.rooms_in_fork.each do |room|
                descriptions << room.description
            end
            descriptions << "Take a moment to converse with your fellow adventurers."
            descriptions << "Flee to safety"
            choice_names << "View Party"
            choice_names << "To Tavern"
            values << "View Party"
            values << "To Tavern"
            new_fork = false
            while new_fork == false
                display("")
                choice = Menu.start(choice_names,values,Curses.lines-6,0,descriptions)
                if choice == "To Tavern"
                    Tavern.new(@party,@text_log)
                    @depth = 1
                    @fork_instance = Fork.new(@depth)
                    new_fork = true
                elsif choice == "View Party"
                    display(choice)
                    view_adventurer_loop
                else
                    choice.door_selection(self)
                    @depth += 1
                    @fork_instance = Fork.new(@depth)
                    new_fork = true
                end
            end
        end
    end

    def view_adventurer_loop
        not_done = true
        while not_done == true
            display("View Party")
            input = Menu.start(["Use Potion","Back"],["Use Potion","Back"],Curses.lines-6,1,["It's like a doctor in a bottle!","Finished viewing? Back to the dungeon."])
            case input
            when "Use Potion"
                potion = Menu.start(["Potion","Elixir"],["Potion","Elixir"],Curses.lines-11,0,["Restores half HP.    Potions: #{@party.potions}" ,"Restores half MP.    Elixirs: #{@party.elixirs}"])
                case potion
                when "Potion"
                    if @party.potions > 0
                    arr =[]
                        @party.heroes_array.length.times do
                        arr << ""
                        end
                    hero_instance = Menu.start(arr,@party.heroes_array,1,0,[],3)
                        if hero_instance.current_HP == hero_instance.max_HP
                            @text_log.write("#{hero_instance.name} refuses to drink the vile solution as they are at full health.")
                        else
                            give_potion(hero_instance, Action.use_potion)
                            @party.potions -= 1
                        end
                    else 
                        @text_log.write("Potion not used. Insufficient amount of potions in inventory.")
                    end
                when "Elixir"
                    if @party.elixirs > 0
                    arr =[]
                        @party.heroes_array.length.times do
                        arr << ""
                        end
                    hero_instance = Menu.start(arr,@party.heroes_array,1,0,[],3)
                        if hero_instance.current_MP == hero_instance.max_MP
                            @text_log.write("#{hero_instance.name} refuses to drink the vile solution as they are at full mana.")
                        else
                        give_potion(hero_instance, Action.use_elixir)
                        @party.elixirs -= 1
                        end
                    else 
                        @text_log.write("Elixir not used. Insufficient amount of elixers in inventory.")
                    end
                end
            when "Back"
                not_done = false
            end
        end
    end

    def give_potion(target, action)
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
        if heal_amount > 0
            @text_log.write("#{target.name} gratefully accepts the potion. They healed #{heal_amount} HP.")
        end
        if restore_amount > 0
            @text_log.write("#{target.name} gratefully accepts the elixir. They restored #{restore_amount} MP.")
        end
    end


    def display(string="")
        Curses.clear
        @party.standard_menu_display
            if string == "View Party"
                display_adventurers(@party.heroes_array)
                @text_log.display_text
            elsif string == "cutscene"
                @text_log.display_text
            else
                @fork_instance.display_doors
                @text_log.display_text
            end
        Curses.setpos(0,76)
        Curses.addstr "Depth: #{@depth}"
        Curses.setpos(1,76)
        Curses.addstr "Coins: #{@party.money}"
        Curses.refresh
    end

    def display_adventurers(array)
        Curses.setpos(1,76)
        Curses.addstr"Coins: #{@party.money}"
        start_display_line = 1
        array.length.times do  |counter|
            Curses.setpos(start_display_line+counter*3,5)
            Curses.addstr " #{array[counter].name}"
            Curses.setpos(start_display_line+counter*3,17) 
            Curses.addstr " #{array[counter].job}"
            Curses.setpos(start_display_line+counter*3,27)
            Curses.addstr"HP: #{array[counter].current_HP} / #{array[counter].max_HP}"
            Curses.setpos(start_display_line+counter*3,41)
            Curses.addstr"MP: #{array[counter].current_MP} / #{array[counter].max_MP}"
            Curses.setpos(start_display_line+counter*3,55)
            Curses.addstr"ATK: #{array[counter].atk}"
            Curses.setpos(start_display_line+counter*3,64)
            Curses.addstr"DEF: #{array[counter].defense}"
            Curses.setpos(start_display_line+counter*3+1,10)
            Curses.addstr"#{array[counter].skill1.action_name}: #{array[counter].skill1.description}"
            Curses.setpos(start_display_line+counter*3+2,10)
            Curses.addstr"#{array[counter].skill2.action_name}: #{array[counter].skill2.description}"
        end
    end

    def final_room
        delay = 1.3
        @text_log = Text_Log.new
        @text_log.lines_of_Text[6]=("Having defeated every obstacle that stands in your way, you stand triumphant.")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[5]=("Your weary party breaths a collective sigh of relief.")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[4]=("Suddenly, two figures appear before you.")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[3]=("\"Hey! We're the game developers! Thank you so much for playing our game.\" says one")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[2]=("\"We really hope that you enjoyed it!\" says the other")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[1]=("\"Now we give you a choice.\"")
        sleep(delay)
        display("cutscene")
        @text_log.lines_of_Text[0]=("\"Do you wanna do the secret developer fight?\"")
        sleep(delay)
        display("cutscene")
        sleep(delay)
        choice = Menu.start(["No","Yes"],["No","Yes"],Curses.lines-6,0,["Congratulations on your victory!","You won't like what comes next."])
        case choice
        when "Yes"
            monsters_position = []
            monsters_position << Monster.final_boss(0)
            monsters_position << Monster.final_boss(1)
            CombatManager.new(@party,monsters_position,@text_log,31)
            win_game()
        when "No"
            win_game()
        end
    end

    def win_game
        counter = 5
            5.times do
                    Curses.clear
                Curses.setpos(10,10)
                Curses.addstr"Your party was victorious. You have won the game!"
                Curses.setpos(11,10)
                Curses.addstr"Game will automatically exit in 5 seconds. But your characters will be in the tavern when you get back!"
                Curses.setpos(12,10)                
                Curses.addstr"Game terminating in #{counter}."
                Curses.refresh
                counter -= 1
                sleep(1)
            end
        exit
    end
end