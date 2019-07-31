class Party
    attr_accessor :heroes_array
    attr_accessor :money, :potions, :elixers, :hipotions, :hielixers
    def initialize
        @money = 0
        @potions = 0
        @elixers = 0
        @hipotions = 0
        @hielixers = 0
        @heroes_array = []
        4.times do 
            @heroes_array << Adventurer.generate_new_adventurer_with_job
        end
    end

    def add_to_party(member_instance)
        self.heroes_array << member_instance
    end

    def remove_party_member(hero_instance)
        self.heroes_array.delete(hero_instance)
    end

    def add_party_member
        
    end

end