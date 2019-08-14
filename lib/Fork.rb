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
        @doors_array = generate_doors
    end

    def generate_rooms
        rooms = rand(2)+2

        if @dungeon_depth == 31
            @rooms_in_fork << Room.new(@dungeon_depth)
            @room_labels << "The End"
        elsif @dungeon_depth % 10 == 0
                @rooms_in_fork << Room.new(@dungeon_depth)
                @room_labels << "Passage"
        else
            rooms.times do |counter|
            @rooms_in_fork << Room.new(@dungeon_depth)
            @room_labels << "Door #{counter+1}"
            end
        end
    end

    def get_door_appearance(room)
        string = []
        case room.door_appearance
        when "wooden_door"
        string = ["     ______     ",
        "  ,-' ;  ! `-.  ",
        " / :  !  :  . \\ ",
        "|_ ;  :  !  .  |",
        ")| .  :  .  !  |",
        "|/ .  :  .  _  |",
        "|  :  :  ! (_) (",
        "|  :  :  .     |",
        ")_ !  ,  :  :  |",
        "|| .  .  :  :  |",
        "|/ .  :  :  .  |",
        "|____;-----;___|"]

        when "fancy_door"
        string = ["_____~/()\\~_____",
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

        when "modern_door"
        string =   [" ______________",
                    "|  |  |  |  |  |",
                    "|  |--------|  |",
                    "|  | œwç ∂ß |  |",
                    "|  |  ∂ßœƒ  |  |",
                    "|  |--------| _|",
                    "|  |  |  |  | U|",
                    "|  |  |  |  |  |",
                    "|  |  |  |  |  |",
                    "|  |  |  |  |  |",
                    "|  |  |  |  |  |",
                    "|__|__|__|__|__|"]

        when "passage_way"
        string =   ["        ____    ",
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
    end


    def generate_doors
        doors_array = []
        @rooms_in_fork.each do |room|
            doors_array << get_door_appearance(room)
        end
        return doors_array
    end

    def display_doors
        top = 7
        left = 10
        midleft = 30
        mid = 50
        midright = 70
        right = 90
        case @doors_array.length
        when 1
            draw_door(@doors_array[0],top,mid)
        when 2
            draw_door(@doors_array[0],top,midleft)
            draw_door(@doors_array[1],top,midright)
        when 3
            draw_door(@doors_array[0],top,left)
            draw_door(@doors_array[1],top,mid)
            draw_door(@doors_array[2],top,right)
        end
    end

    def draw_door(door_string,y,x)
        door_string.length.times do |counter|
            Curses.setpos(y+counter,x)
            Curses.addstr(door_string[counter])
        end
    end       
end