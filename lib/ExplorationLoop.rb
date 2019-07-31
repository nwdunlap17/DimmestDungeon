class ExplorationLoop
    attr_accessor :depth
    def initialize

        @depth = 0
    end

    def select_room(fork_instance)
        room = Menu.start(fork_instance.room_numbers,fork_instance.rooms_in_fork,10,0)
        room.door_selection
        @depth += 1
    end


end