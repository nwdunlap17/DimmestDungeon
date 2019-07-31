class Treasure < ActiveRecord::Base
    belongs_to :adventurer
    belongs_to :monster

    def self.LoadTreasures
        # Treasure.defineMagicItem("Belt of Endurance",10,0,0,0)
        # Treasure.defineMagicItem("Ring of Rage",0,0,2,0)
        # Treasure.defineMagicItem("Circlet of Power",0,4,0,0)
        # Treasure.defineMagicItem("Bangle of Defense",0,0,0,2)
        # Treasure.defineMagicItem("Helm of Might",5,0,1,0)
        # Treasure.defineMagicItem("Magic Bracers",0,2,0,1)
        Treasure.defineMoney("Small Bag of Coins",20)
        Treasure.defineMoney("Large Bag of Coins",50)
        Treasure.defineMoney("Small Treasure Chest",200)
        Treasure.defineMoney("Large Treasure Chest",500)
        Treasure.defineMoney("Portrait",100)
        Treasure.defineMoney("Giant Diamond",1000)
        Treasure.defineMoney("The Biggest Diamond",5000)
    end

    def self.defineMagicItem(name,max_HP,rarity,max_MP,atk,defense)
        treas = Treasure.new()
        treas.name = name
        treas.rarity = "rare"
        treas.type = "Magic Item"
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
        description = description.chomp
        treas.description = description
        treas.save
    end

    def self.defineMoney(name,value)
        treas = Treasure.new
        treas.type = "Money"
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

    def self.GivePartyTreasure(party, rarity_bonus)
        rarity_roll = rand(100) + rarity_bonus

        if rarity_roll <75 
            rarityvalue = "common"
        elsif rarity_roll >= 76 && rarity_roll < 98
            rarityvalue = "uncommon"
        elsif rarity_roll >= 98
            rarityvalue = "rare"
        end

        treasures = Treasure.where(rarity: rarityvalue)
        given_treasure = treasures.sample

        case given_treasure.type
        when "Magic Item"
        when "Money"
            give_money_to_party(party,given_treasure)
        when "Potion"
        end
    end

    def self.give_money_to_party(party,given_treasure)
        value_mod = 100 + rand(41) - 20
        value_mod = value_mod /100.0
        total_worth = given_treasure.value * value_mod
        
        party.money += total_worth
    end
end