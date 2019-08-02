class ExplorationLoop
    attr_accessor :depth, :text_log
    def initialize
        @text_log = Text_Log.new
        @party = Party.new
        @depth = 1
        select_room
    end

    def select_room
        while true
            if @depth == 1
                @text_log.write("You enter the dungeon...")
            end
            fork_instance = Fork.new(@depth)
            choice_names = fork_instance.room_labels 
            values = fork_instance.rooms_in_fork
            descriptions = []
            fork_instance.rooms_in_fork.each do |room|
                descriptions << room.description
            end
            descriptions << "View Party"
            descriptions << "Flee to safety"
            choice_names << "View Party"
            choice_names << "To Tavern"
            values << "View Party"
            values << "To Tavern"
            display
            # choice = fork_instance.rooms_in_fork[0]
            choice = Menu.start(choice_names,values,Curses.lines-6,0,descriptions)
            if choice == "To Tavern"
                @depth = 0
                Tavern.new(@party,@text_log)
            elsif choice == "View Party"
                display(choice)
                view_adventurer_loop
            else
            choice.door_selection(@party,@text_log)
            end
            @depth += 1
        end
    end

    def view_adventurer_loop
        not_done = true
        while not_done == true
            display("View Party")
            input = Menu.start(["Use Potion","Back"],["Use Potion","Back"],Curses.lines-6,1)
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
                    give_potion(hero_instance, Action.use_potion)
                    @party.potions -= 1
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
                    give_potion(hero_instance, Action.use_elixir)
                    @party.elixirs -= 1
                    else 
                        @text_log.write("Elixir not used. Insufficient amount of potions in inventory.")
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
            @text_log.write("You used a health potion on #{target.name}. They healed #{heal_amount} HP.")
        end
        if restore_amount > 0
            @text_log.write("You used an elixir on #{target.name}. They restored #{restore_amount} MP.")
        end
     end

    def display(string="")
        Curses.clear
        @party.standard_menu_display
            if string == "View Party"
                display_adventurers(@party.heroes_array)
            else 
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
        Curses.addstr"Coins:#{@party.money}"
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
end