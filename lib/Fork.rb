class Fork
    #when at the fork, the fork will generate the door appearance and the door description
    #then when a player selects a door option, the actual door contents are revealed, this can be used in ExplorationLoop
    attr_accessor :depth, :amount_of_rooms, :dungeon_depth, :rooms_in_fork, :fork_actions, :room_labels

    def initialize(depth)
        @dungeon_depth = depth
        @room_labels = []
        @rooms_in_fork = []
        generate_rooms
        @amount_of_rooms = @rooms_in_fork.length
    end

    def generate_rooms
        rooms = rand(2)+2
        if @dungeon_depth % 10 == 0
            @rooms_in_fork << Room.new(@dungeon_depth)
            @room_labels << "Door 1"
        else
            rooms.times do |counter|
            @rooms_in_fork << Room.new(@dungeon_depth)
            @room_labels << "Door #{counter+1}"
            end
        end
    end

    def doors
    boss_room = ["    ______     ",
    "  ,-' ;  ! `-.  ",
    " / :  !  :  . \ ",
    "|_ ;  :  !  .  |",
    ")| .  :  .  !  |",
    "|/ .  :  .  _  |",
    "|  :  :  ! (_) (",
    "|  :  :  .     |",
    ")_ !  ,  :  :  |",
    "|| .  .  :  :  |",
    "|/ .  :  :  .  |",
    "|____;-----;___|"]


    treasure_room = ["_____~/()\~_____",
    "|   ___  ___   |",
    "|  |   ||   |  |",
    "|  |   ||   |  |",
    "|  |___||___|  |",
    "|  +========+  |",
    "|   ___  ___ ()|",
    "|  |   ||   | !|",
    "|  |   ||   |  |",
    "|  |   ||   |  |",
    "|  |___||___|  |",
    "|______________|"]

    safe_room = [" ______________",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|  |  |  |  | _|",
    "|  |  |  |  | U|",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|  |  |  |  |  |",
    "|__|__|__|__|__|"]


    monster_room = ["        ____    ",
    "     __/    \\   ",
    "    /        \\  ",
    "   |          \\ ",
    "   \\          / ",
    "   /         /  ",
    " /           \\  ",
    " \\            \\ ",
    " /             \\",
    "|              |",
    "/             / ", 
    "\\            /  "]
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
            Curses.setpos(y+counter,x)
        end
        Curses.refresh
    end       
end