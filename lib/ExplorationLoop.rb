class ExplorationLoop
    attr_accessor :depth :text_log
    def initialize
        @text_log = Text_Log.new
        @depth = 0
    end

    def select_room(fork_instance)
        choices = fork_instance.room_numbers 
        choices << "Leave"
        room = Menu.start(choices,fork_instance.rooms_in_fork,10,0)
        if room = "Leave"
            @depth = 0
            #start TavernLoop
        end
        room.door_selection
        @depth += 1
    end


end