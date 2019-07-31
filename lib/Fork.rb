class Fork
    #when at the fork, the fork will generate the door appearance and the door description
    #then when a player selects a door option, the actual door contents are revealed, this can be used in ExplorationLoop
    attr_accessor :depth, :amount_of_rooms, :dungeon_depth, :rooms_in_fork, :fork_actions

    def initialize(depth)
        @dungeon_depth = depth
        @amount_of_rooms = generate_rooms
        @rooms_in_fork = []
        @fork_actions = []
    end

    def generate_rooms
        rooms = rand(3)+1
        @dungeon_depth = depth
        if depth % 10 != 0
            @rooms_in_fork << Room.new(depth)
        else
            rooms.times do 
            @rooms_in_fork << Room.new(depth)
            end
        end
    end

    def display_doors
        
    end

    def door_selection
        @rooms_in_fork.each do |room|
            case room.room_type 
            when "treasure_room"
                @fork_actions << room.enter_treasure_room
            when "monster_room"
                @fork_actions << room.enter_monster_room
            when "safe_room"
                @fork_actions << room.enter_safe_room
            when "boss_room"
                @fork_actions << room.enter_boss_room
            end   
        end
    end         
end