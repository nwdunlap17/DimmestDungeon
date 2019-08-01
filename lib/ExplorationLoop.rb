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
            fork_instance = Fork.new(@depth)
            choice_names = fork_instance.room_labels 
            values = fork_instance.rooms_in_fork
            descriptions = []
            fork_instance.rooms_in_fork.each do |room|
                descriptions << room.description
            end
            descriptions << "Flee to safety"
            choice_names << "Leave"
            values << "Leave"
            display
            # choice = fork_instance.rooms_in_fork[0]
            choice = Menu.start(choice_names,values,Curses.lines-6,0,descriptions)
            if choice == "Leave"
                @depth = 0
                Tavern.new(@party,@text_log)
            else
            choice.door_selection(@party,@text_log)
            end
            @depth += 1
        end
    end

    def display()
        Curses.clear
        @party.standard_menu_display
        Curses.setpos(0,76)
        Curses.addstr "Depth: #{@depth}"
        Curses.setpos(1,76)
        Curses.addstr "Coins: #{@party.money}"
        Curses.refresh
    end
end