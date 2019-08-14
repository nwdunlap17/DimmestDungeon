class Room
# another method will call on the rooms
# rooms need to know what kind of room it is
    attr_accessor :description, :door_appearance, :room_type
    
    def initialize(depth)
    @dungeon_depth = depth
    @room_type = ""
    @door_appearance = ""
    set_type
    end

    def set_type
        if @dungeon_depth == 31
            final_room
        elsif @dungeon_depth % 10 != 0
            room_choice = rand(5)
            case room_choice
                when 0
                treasure_room
                when 1
                safe_room
                else
                monster_room
            end
        else 
            boss_room
        end
    end

    def treasure_room
        @door_appearance = "fancy_door"
        descriptors = ["beautiful","magnificient","gorgeous","golden","splendid","brilliant","shining","glorious","grand","grandiose","stately","noble","marvelous"]
        door_description = "Ahead stands a " + descriptors.sample + " door, which leaves your party awestruck."
        @description = door_description
        @room_type = "treasure_room"
        #puts "You've found a treasure chest!"
    end

    def enter_treasure_room(party_instance,text_log)
        Treasure.GivePartyTreasure(party_instance,@dungeon_depth,text_log)
    end

    def monster_room
        @door_appearance = "wooden_door"
        descriptors = ["imposing","monstrous","ominous","dreadful","gloomy","ghastly","horrid","hideous","macabre","unpleasant","terrifying","repulsive","revolting","distasteful","sanguine"]
        door_description = "Looming ahead, a " + descriptors.sample + " door beckons..."
        @description = door_description
        @room_type = "monster_room"
    end

    def enter_monster_room(party_instance,text_log)
        amount_slimes = rand(4)+1
        monsters_position = []
        length = Monster.all.length
        amount_slimes.times do
            power = 2 + (@dungeon_depth/5)
            range = 1
            if power > 9
                power == 9
            end
            monsters_position << Monster.new_monster(power,range)
        end
        CombatManager.new(party_instance,monsters_position,text_log,@dungeon_depth)
        if rand(3) == 0
            text_log.write("You find treasure!")
            Treasure.GivePartyTreasure(party_instance,@dungeon_depth+10,text_log)
        end
    end

    def safe_room
        @door_appearance = "modern_door"
        descriptors = ["enticing haven","blissful sanctuary","protected garden","secure home","guarded asylum","preserved alcove","hallowed clearing"]
        door_description = "An inscription on the door reads: Within lies a " + descriptors.sample + " blessed with protective sigils."
        @description = door_description
        @room_type = "safe_room"
    end

    def enter_safe_room(party_instance,text_log)
        #input is a party instance's heroes_array => which contains adventurer instances
        party_instance.heroes_array.each do |hero|
            text_log.write("#{hero.name} has been healed for #{hero.max_HP - hero.current_HP} health! Health is now #{hero.max_HP}/#{hero.max_HP}.")
            hero.current_HP = hero.max_HP
        end
        text_log.write("Party is fully healed.")
        #in future, heals random amount based on how much health
    end

    def boss_room
        @door_appearance = "passage_way"
        @description = "Heavy breaths sends hot, repugnant air over your party. Something sinister lies beyond."
        @room_type = "boss_room"
    end
    
    def enter_boss_room(party_instance,text_log)
        monsters_position = []
        monsters_position << Monster.new_boss_monster(4+(@dungeon_depth/5))
        CombatManager.new(party_instance,monsters_position,text_log,@dungeon_depth)
        Treasure.GivePartyTreasure(party_instance,@dungeon_depth+90,text_log)
    end

    def final_room 
        @door_appearance = "safe_room"
        @description = "Your trials over, victory is at hand."
        @room_type = "final_room"
    end
    def enter_final_room(exploreloop)
        exploreloop.final_room
    end

    def door_selection(exploreloop)
        party_instance = exploreloop.party
        text_log = exploreloop.text_log
        case @room_type 
            when "treasure_room"
                enter_treasure_room(party_instance,text_log)
            when "monster_room"
                enter_monster_room(party_instance,text_log)
            when "safe_room"
                enter_safe_room(party_instance,text_log)
            when "boss_room"
                enter_boss_room(party_instance,text_log) 
            when "final_room"
                enter_final_room(exploreloop) 
        end
    end  
end



