
class Monster  < ActiveRecord::Base
    has_many :treasures
    has_many :monsters, through: :treasures
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
            health = minion_hash["cost"] * minion_hash["health"] + 1
            name = minion_hash["name"]
            level = minion_hash["cost"]
            description = minion_hash["flavor"]
            Monster.create(name: name, description: description, atk: attack, defense: 0, max_HP: health, level: level)
        end
    end

    def new_boss_monster
        new_monster = Monster.find_by(level:6)
        new_monster.get_ready_for_combat
        return new_monster
    end

    def new_monster
        new_monster = Monster.find_by(level:3)
        new_monster.get_ready_for_combat
        return new_monster
    end
end