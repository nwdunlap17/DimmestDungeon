class Party
    attr_accessor :heroes_array
    attr_accessor :money, :potions, :elixers, :hipotions, :hielixers
    def initialize
        @money = 10
        @potions = 1
        @elixers = 1
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

    def standard_menu_display
        display_adventurers
        display_menu_outline
        Curses.setpos(1,76)
        Curses.add "Coins #{@money}"
    end

    
    def display_menu_outline
        Curses.setpos(Curses.lines-7,0)
        Curses.addstr ("-" * (Curses.cols))
        6.times do |i|
            Curses.setpos(Curses.lines-6+i,18)
            Curses.addstr("|")
        end
        Curses.setpos(Curses.lines-5,19)
        Curses.addstr ("-"*(Curses.cols-19))
    end

    def display_adventurers
        start_display_line = Curses.lines-4
        @heroes_array.length.times do  |index|
            Curses.setpos(start_display_line+index,20)
            Curses.addstr " #{heroes_array[index].name}"
            Curses.setpos(start_display_line+index,36)
            Curses.addstr"HP: #{heroes_array[index].current_HP} / #{heroes_array[index].max_HP}"
            Curses.setpos(start_display_line+index,50)
            Curses.addstr"MP: #{heroes_array[index].current_MP} / #{heroes_array[index].max_MP}"
        end
    end
end