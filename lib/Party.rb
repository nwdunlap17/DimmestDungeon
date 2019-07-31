class Party
    attr_accessor :heroes_array
    def initialize
        @heroes_array = []
        4.times do 
            @heroes_array << Adventurer.generate_new_adventurer_with_job
        end
    end

    def add_to_party
    end

    def remove_party_member
    end

end