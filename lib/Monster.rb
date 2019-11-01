
class Monster  < ActiveRecord::Base
    has_many :treasures
    has_many :monsters, through: :treasures 
    attr_accessor :is_boss
    include Combatant

    def self.manual_generation(name="Foo",atk=4,defense=0,max_HP=10)
        mon = Monster.new
        mon.name = name
        mon.atk = atk
        mon.defense = defense
        mon.max_HP = max_HP
        mon.current_HP = max_HP
        mon.reset_buffs
        return mon
    end

    def self.load_monsters
        api_response = RestClient.get("https://api.hearthstonejson.com/v1/25770/enUS/cards.json")
        monster_json = JSON.parse(api_response)
        new_monster = monster_json.select do |monster_hash|
            monster_hash["type"] == "MINION" && !!monster_hash["flavor"]
        end
        new_monster.each do |minion_hash|
            attack = minion_hash["attack"]
            health = (minion_hash["cost"] * minion_hash["health"] +1)
            name = minion_hash["name"]
            level = minion_hash["cost"]
            description = minion_hash["flavor"]
            if description.length <= 95 
                Monster.create(name: name, description: description, atk: attack, defense: 0, max_HP: health, level: level)
            end
        end
        Monster.create(name: "Katana", description: "She's just happy to be here.", atk: 6, defense: 0, max_HP: 70, level: 0)
        Monster.create(name: "Nick", description: "Really sorry about killing you.", atk: 4, defense: 0, max_HP: 120, level: 0)
    end

    def self.new_boss_monster(power = 6)
        new_monster = Monster.where(level:6).sample
        new_monster.atk = new_monster.atk * 3
        new_monster.max_HP = new_monster.max_HP * 10
        new_monster.is_boss = true
        new_monster.get_ready_for_combat
        return new_monster
    end
    
    def self.final_boss(choice)
        names = ""
    if choice == 0
        names = "Katana"
    else 
        names = "Nick"
    end
    new_monster = Monster.find_by(name:names)
    new_monster.atk = new_monster.atk * 3
    new_monster.max_HP = new_monster.max_HP * 10
    new_monster.is_boss = true
    new_monster.get_ready_for_combat
    return new_monster
    end

    def self.new_monster(power = 3, range = 0)
        power = power + rand(range)
        new_monster = Monster.where(level:3).sample
        new_monster.atk = new_monster.atk * 2
        new_monster.max_HP = new_monster.max_HP * 5
        new_monster.is_boss = false
        new_monster.get_ready_for_combat
        return new_monster
    end
end