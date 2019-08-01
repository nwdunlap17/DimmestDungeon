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
            input = Menu.start(["Use Potion","Back"],["Dismiss","Back"],Curses.lines-6,1)
            case input
            when "Use Potion"
                potion = Menu.start(["Potion","Elixir"],["Potion","Elixir"],1,0,["Restores half HP","Restores half MP"],3)
                case potion
                when "Potion"
                    #addition of potion
                when "Elixir"
                    #addition of elixir
                end
            when "Back"
                not_done = false
            end
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