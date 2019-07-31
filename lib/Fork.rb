class Fork
    #when at the fork, the fork will generate the door appearance and the door description
    #then when a player selects a door option, the actual door contents are revealed, this can be used in ExplorationLoop
    attr_accessor :depth, :amount_of_rooms, :dungeon_depth, :rooms_in_fork, :fork_actions

    def initialize(depth)
        @dungeon_depth = depth
        @amount_of_rooms = generate_rooms
        @room_numbers = []
        @rooms_in_fork = []
    end

    def generate_rooms
        rooms = rand(3)+1
        @dungeon_depth = depth
        if depth % 10 != 0
            @rooms_in_fork << Room.new(depth)
            @room_numbers << "Door 1"
        else
            rooms.times do |counter|
            @rooms_in_fork << Room.new(depth)
            @room_numbers << "Door #{counter}"
            end
        end
    end

    def wooden_door
        wooden_door = ["___________","|  |  |  | |","|  |  |  | |","|  |  |  | |","|  |  |  |_|","|  |  |  |U|","|  |  |  | |","|  |  |  | |","|  |  |  | |","|__|__|__|_|"]
        return wooden_door
    end

    def draw_many_doors 
        Curse.clear
        draw_door(door_string,y,x)
        draw_door(door_string,y,x)
        draw_door(door_string,y,x)
    end

    def draw_door(door_string,y,x)
        Curses.setpos(y,x)
        door_string.length.times do |counter|
            Curses.addstr(door_string[counter])
            Curses.setpos(y+counter)(x)
        end
        Curses.refresh
    end       
end