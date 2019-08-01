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
        choices << "Leave"
        display
        room = Menu.start(choices,fork_instance.rooms_in_fork,10,0)
        if room == "Leave"
            @depth = 0
            Tavern.new(@party)
        end
        room.door_selection(@party,@text_log)
        @depth += 1
        end
    end

    def display()
        Curses.clear
        @party.standard_menu_display
        Curses.setpo(0,53)
        Curses.addstr "Depth: #{@depth}"
        Curses.refresh
    end
end