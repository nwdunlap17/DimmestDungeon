class ExplorationLoop
    attr_accessor :depth, :text_log
    def initialize
        @text_log = Text_Log.new
        @party = Party.new
        @depth = 0
    end

    def select_room(fork_instance)
        while true
        choices = fork_instance.room_numbers 
        choices << "Exit Dungeon"
        display
        room = Menu.start(choices,fork_instance.rooms_in_fork,10,0)
<<<<<<< HEAD
        if room == "Leave"
=======
        if room == "Exit Dungeon"
>>>>>>> 89205565d0fcdb0de156270c986422723d72cf74
            @depth = 0
            Tavern.new(@party)
        end
        room.door_selection(@party,@text_log)
        @depth += 1
        end
    end

    def display()
        Curses.clear
        display_menu_outline
        display_adventurers
        Curses.refresh
    end
    
    def display_menu_outline
        Curses.setpos(13,0)
        Curses.addstr ("-"*61)
        6.times do |i|
            Curses.setpos(14+i,18)
            Curses.addstr("|")
        end
        Curses.setpos(15,19)
        Curses.addstr ("-"*42)
    end

    def display_adventurers
        start_display_line = 16
        @party.heroes_position.length.times do  |index|
            Curses.setpos(start_display_line+index,20)
            Curses.addstr " #{heroes_position[index].name}"
            Curses.setpos(start_display_line+index,36)
            Curses.addstr"HP: #{heroes_position[index].current_HP} / #{heroes_position[index].max_HP}"
            Curses.setpos(start_display_line+index,50)
            Curses.addstr"MP: #{heroes_position[index].current_MP} / #{heroes_position[index].max_MP}"
        end
    end
end