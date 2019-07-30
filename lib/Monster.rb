class Monster < ActiveRecord::Base
    include Combatant
    attr_accessor :name

    def initialize
        super
        @monster_description = ""
    end

    def self.load_monsters
        api_response = RestClient.get("https://api.hearthstonejson.com/v1/25770/enUS/cards.json")
        monster_json = JSON.parse(api_response.body)
        new_monster = monster_json.select do |monster_hash|
            monster_hash[:type] == "MINION"
        end
    end
end