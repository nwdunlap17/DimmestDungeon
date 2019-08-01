class Tavern
    attr_accessor :carousel
    def initialize(party)
        @carousel = []
        @party = party
        TavernLoop
    end

    def TavernLoop
        still_in_town = true

        while still_in_town
            display
            choices = ["Recruit Member","View Party","To Dungeon","Quit Game"]
            input = Menu.start(choices,choices,14,1)
            case input
            when "Recruit Member"
                display(input)
            when "View Party"
                display(input)
            when "To Dungeon"
                #exploration loop
                still_in_town = false
            when "Quit Game"
                exit
            end
        end
    end

    def display(string="")
        Curses.clear
        display_menu_outline
        display_adventurers
        case string
        when "Recruit Member"
            @carousel
        when "View Party"
            @party.heroes_position
        when ""
        end

        Curses.refresh
    end

    def stats_display(input)
        start_display_line = 7
        input.length.times do  |index|
            Curses.setpos(start_display_line+index,10)
            Curses.addstr " #{input[index].name}"
            Curses.setpos(start_display_line+index,26)
            Curses.addstr"HP: #{input[index].max_HP}"
            Curses.setpos(start_display_line+index,34)
            Curses.addstr"MP: #{input[index].max_MP}"
            Curses.setpos(start_display_line+index,42)
            Curses.addstr"ATK: #{input[index].atk}"
            Curses.setpos(start_display_line+index,51)
            Curses.addstr"DEF: #{input[index].defense}"
        end
    end
    
    def display_menu_outline
        Curses.setpos(13,0)
        Curses.addstr ("-"*61)
        6.times do |i|
            Curses.setpos(14+i,18)
            Curses.addstr("|")
        end
        Curses.setpos(15,19)
        Curses.addstr ("-"*42)
    end

    def recruit_member
        if party.heroes_array.length < 4
            Menu.new([])
        else 
            @text_log.write("Your party is full!")
        end
    end

    def display_adventurers
        start_display_line = 16
        @party.heroes_position.length.times do  |index|
            Curses.setpos(start_display_line+index,20)
            Curses.addstr " #{heroes_position[index].name}"
            Curses.setpos(start_display_line+index,36)
            Curses.addstr"HP: #{heroes_position[index].current_HP} / #{heroes_position[index].max_HP}"
            Curses.setpos(start_display_line+index,50)
            Curses.addstr"MP: #{heroes_position[index].current_MP} / #{heroes_position[index].max_MP}"
        end
    end

    def display_carousel
        4.times do 
           @carousel <<  Adventurer.generate_new_adventurer_with_job
        end
    end

    def refresh_carousel(party_instance)
        if party_instance.money >= 5
            party_instance.money = party_instance.money - 5
            @carousel = []
            display_carousel
        end
    end
        
end
    