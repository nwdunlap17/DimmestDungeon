class Treasure < ActiveRecord::Base

    def self.LoadTreasures
        Treasure.defineMagicItem("Belt of Endurance",10,0,0,0)
        Treasure.defineMagicItem("Ring of Rage",0,0,2,0)
        Treasure.defineMagicItem("Circlet of Power",0,4,0,0)
        Treasure.defineMagicItem("Bangle of Defense",0,0,0,2)
        Treasure.defineMagicItem("Helm of Might",5,0,1,0)
        Treasure.defineMagicItem("Magic Bracers",0,2,0,1)
        Treasure.defineMoney("Small Bag of Coins",20)
        Treasure.defineMoney("Large Bag of Coins",50)
        Treasure.defineMoney("Small Treasure Chest",200)
        Treasure.defineMoney("Large Treasure Chest",500)
        Treasure.defineMoney("Portrait",100)
        Treasure.defineMoney("Giant Diamond",1000)
        Treasure.defineMoney("Massive Diamond",5000)
        Treasure.definePotion("Potions",2,0)
        Treasure.definePotion("Elixers",0,2)
        Treasure.definePotion("ManyPotions",3,0)
        Treasure.definePotion("ManyElixers",0,3)
        Treasure.definePotion("PotionsAndElixers",2,2)
    end

    def self.defineMagicItem(name,max_HP,max_MP,atk,defense)
        treas = Treasure.new()
        treas.name = name
        treas.rarity = "rare"
        treas.treasure_type = "Magic Item"
        treas.max_HP = max_HP
        treas.max_MP = max_MP
        treas.attack = atk
        treas.defense = defense
        descriptors = []
        if max_HP > 0
            descriptors << "Max HP +#{max_HP}"
        end
        if max_MP > 0
            descriptors << " Max MP +#{max_MP}"
        end
        if atk > 0
            descriptors << " ATK +#{atk}"
        end
        if defense > 0
            descriptors << " DEF +#{defense}"
        end
        description = descriptors.join(',')
        description = description.strip
        treas.description = description
        treas.save
    end

    def self.defineMoney(name,value)
        treas = Treasure.new
        treas.treasure_type = "Money"
        treas.name = name
        if value <= 100
            treas.rarity = "common"
        elsif value <= 1000
            treas.rarity = "uncommon"
        else
            treas.rarity = "rare"
        end
        treas.value = value
        treas.description = "It's worth #{value} coins."
        treas.save
    end

    def self.definePotion(name,potquantity,elixerquantity)
        treas = Treasure.new
        treas.name = name
        treas.treasure_type = "Potion"
        treas.rarity = "uncommon"
        treas.potions = potquantity
        treas.elixers = elixerquantity
        treas.save
    end

    def self.GivePartyTreasure(party, rarity_bonus,text_log)
        rarity_roll = rand(100) + rarity_bonus
        rarity_roll = 80
        if rarity_roll <75 
            rarityvalue = "common"
        elsif rarity_roll >= 76 && rarity_roll < 98
            rarityvalue = "uncommon"
        elsif rarity_roll >= 98
            rarityvalue = "rare"
        end
        treasures = Treasure.where(rarity: rarityvalue)
        given_treasure = treasures.sample
        case given_treasure.treasure_type
        when "Magic Item"
            give_magic_item_to_party(party,given_treasure,text_log)
        when "Money"
            give_money_to_party(party,given_treasure,text_log)
        when "Potion"
            give_potion_to_party(party,given_treasure,text_log)
        end
    end

    def self.give_money_to_party(party,given_treasure,text_log)
        value_mod = 100 + rand(41) - 20
        value_mod = value_mod /100.0
        total_worth = given_treasure.value * value_mod
        total_worth = total_worth.round
        party.money += total_worth
        text_log.write("You found a #{given_treasure.name}!")
        text_log.write("It's worth #{total_worth} coins.")
    end
    def self.give_potion_to_party(party,given_treasure,text_log)
        if given_treasure.potions > 0
            text_log.write("You found #{given_treasure.potions} Potions!")
            party.potions += given_treasure.potions
        end
        if given_treasure.elixers > 0
            text_log.write("You found #{given_treasure.elixers} Elixers!")
            party.elixers += given_treasure.elixers
        end
    end
    def self.give_magic_item_to_party(party,given_treasure,text_log)
        self.display(party,given_treasure)
        heros = party.heroes_array
        choices = []
        heros.length.times do 
            choices << ""
        end
        selection = Menu.start(choices,heros,5,16,[],3)
        selection.max_HP += given_treasure.max_HP
        selection.current_HP += given_treasure.max_HP
        selection.max_MP += given_treasure.max_MP
        selection.current_MP += given_treasure.max_MP
        selection.atk += given_treasure.attack
        selection.defense += given_treasure.defense
        Ownership.create(adventurer_id: selection.id, treasure_id: given_treasure.id)
    end
    def self.display(party,given_treasure)
        Curses.clear
        Curses.setpos(2,25)
        Curses.addstr ("You found a #{given_treasure.name}! (#{given_treasure.description})")
        Curses.setpos(3,45)
        Curses.addstr ("Who gets it?")
        party.standard_menu_display
        self.display_adventurers(party)
        Curses.refresh
    end

    def self.display_adventurers(party)
        Curses.setpos(1,76)
        Curses.addstr"Coins:#{party.money}"
        start_display_line = 5
        array = party.heroes_array
        array.length.times do  |counter|
            Curses.setpos(start_display_line+counter*3,19)
            Curses.addstr " #{array[counter].name}"
            Curses.setpos(start_display_line+counter*3,31) 
            Curses.addstr " #{array[counter].job}"
            Curses.setpos(start_display_line+counter*3,41)
            Curses.addstr"HP: #{array[counter].current_HP} / #{array[counter].max_HP}"
            Curses.setpos(start_display_line+counter*3,55)
            Curses.addstr"MP: #{array[counter].current_MP} / #{array[counter].max_MP}"
            Curses.setpos(start_display_line+counter*3,69)
            Curses.addstr"ATK: #{array[counter].atk}"
            Curses.setpos(start_display_line+counter*3,78)
            Curses.addstr"DEF: #{array[counter].defense}"
            Curses.setpos(start_display_line+counter*3+1,24)
            Curses.addstr"#{array[counter].skill1.action_name}: #{array[counter].skill1.description}"
            Curses.setpos(start_display_line+counter*3+2,24)
            Curses.addstr"#{array[counter].skill2.action_name}: #{array[counter].skill2.description}"
        end
    end
end