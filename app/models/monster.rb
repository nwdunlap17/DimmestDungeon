class Monster < ActiveRecord::Base
    has_many :treasures
    has_many :adventurers, through: :treasures

    include Combatant

    def self.load_monsters
        api_response = RestClient.get("https://api.hearthstonejson.com/v1/25770/enUS/cards.json")
        monster_json = JSON.parse(api_response.body)
        new_monster = monster_json.select do |monster_hash|
            monster_hash[:type] == "MINION"
        end
        new_monster.each do |minion_hash|
            attack = minion_hash[:attack]
            health = minion_hash[:cost] * minion_hash[:health]
            name = minion_hash[:name]
            description = minion_hash[:flavor]
            Monster.create(name: name, description: description, atk: attack, defense: 0, max_HP: health)
        end
    end
end