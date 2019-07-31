class Room
# another method will call on the rooms
# rooms need to know what kind of room it is
attr_writer :description, :door_appearance
    def initialize(depth)
    @type = set_type
    @description = ""
    @door_appearance = ""
    @dungeon_depth = depth
    end

    def set_type
        if @dungeon_depth % 10 != 0
            room_choice = rand(3)
            case room_choice
                when 0
                treasure_room
                when 1 
                monster_room
                when 2
                safe_room
            end
        else 
            boss_room
        end
    end

    def treasure_room
        #when at the fork, the fork will generate the door appearance and the door description
        #then when a player selects a door option, the actual door contents are revealed
        @door_appearance = curtain_door
        descriptors = ["beautiful","magnificient","gorgeous","golden","splendid","brilliant","shining","glorious","grand","grandiose","stately","noble","marvelous"]
        door_description = "Ahead stands a" + descriptors.sample + "door, which leaves your party awestruck."
        @description = door_description
        #puts "You've found a treasure chest!"
    end

    def monster_room
        @door_appearance = wooden_door
        descriptors = ["imposing","monstrous","ominous","dreadful","gloomy","ghastly","horrid","hideous","macabre","unpleasant","terrifying","repulsive","revolting","distasteful","sanguine"]
        door_description = "Looming ahead, a" + descriptors.sample + "door beckons..."
        @description = door_description
        amount_slimes = rand(4)+1
        monsters_position = []
        length = Monster.all.length
        amount_slimes.times do
           monsters_position << Monster.find(id:rand(length))
        end
        CombatManager.new(Party.heroes_array,monsters_position)
    end

    def safe_room(party_instance) 
        @door_appearance = modern_door
        descriptors = ["enticing haven","blissful sanctuary","protected garden","secure home","guarded asylum","preserved alcove","hallowed clearing"]
        door_description = "An inscription on the door reads: Within lies an oasis, a " + descriptors.sample + " blessed with protective sigils awaits!"
        @description = door_description
        #input is a party instance's heroes_array => which contains adventurer instances
        party_instance.heroes_array.each do |hero|
            #puts "#{hero.name} has been healed for #{hero.max_HP - hero.current_HP} health! Health is now #{hero.max_HP}/#{hero.max_HP}."
            hero.current_HP = hero.max_HP
        end
        #puts "Party is fully healed."
        #in future, heals random amount based on how much health
    end

    def boss_room
        @door_appearance = passage_way
        @door_description = "Heavy breaths sends hot, repugnant air over your party. By the way the hair sticks up on your neck, you can tell something sinister lies in the depths of this passage."
        monsters_position = []
        monsters_position << Monster.find(level:6)
        CombatManager.new(Party.heroes_array,monsters_position)
    end
end

