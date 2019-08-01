class ExplorationLoop
    attr_accessor :depth, :text_log
    def initialize
        @text_log = Text_Log.new
        @party = Party.new
        @depth = 1
        select_room
    end

    def select_room
        fork_instance = Fork.new(@depth)
        while true
            choice_names = fork_instance.room_labels 
            values = fork_instance.rooms_in_fork
            descriptions = []
            #binding.pry
            fork_instance.rooms_in_fork.each do |room|
                descriptions << room.description
            end
            descriptions << "Flee to safety"
            choice_names << "Leave"
            values << "Leave"
            display
            choice = Menu.start(choice_names,values,Curses.lines-6,0,descriptions)
            if choice == "Leave"
                @depth = 0
                Tavern.new(@party,@text_log)
            end
            choice.door_selection(@party,@text_log)
            @depth += 1
        end
    end

    def display()
        Curses.clear
        @party.standard_menu_display
        Curses.setpos(0,53)
        Curses.addstr "Depth: #{@depth}"
        Curses.refresh
    end
end