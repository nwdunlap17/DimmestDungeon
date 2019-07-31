class Monster  < ActiveRecord::Base
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
        monster_json = JSON.parse(api_response.body)
        new_monster = monster_json.select do |monster_hash|
            monster_hash[:type] == "MINION"
        end
    end
end