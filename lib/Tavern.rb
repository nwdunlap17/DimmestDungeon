class Tavern
    attr_accessor :carousel
    def initialize(party_instance,text_log)
        @carousel = []
        @party = party_instance
        @text_log = text_log
        fill_carousel
        tavernLoop
    end

    def tavernLoop
        still_in_town = true

        while still_in_town
            display
            choices = ["Hire Member","View Party","To Dungeon","Quit Game"]
            input = Menu.start(choices,choices,Curses.lines-6,1)
            case input
            when "Hire Member"
                if @party.heroes_array.length < 4
                    recruit_member_loop
                else 
                    @text_log.write("Your party is full!")
                end
            when "View Party"
                display(input)
                dismiss_member_loop
            when "To Dungeon"
                #exploration loop
                still_in_town = false
            when "Quit Game"
                exit
            end
        end
    end

    def recruit_member_loop
        not_done = true
        while not_done == true
            display("Hire Member")
            input = Menu.start(["Recruit","Refresh","Back"],["Recruit","Refresh","Back"],Curses.lines-6,1)
            case input
            when "Recruit"
            if @party.heroes_array.length < 4
                arr =[]
                @carousel.length.times do
                    arr << ""
                end
                hero_instance = Menu.start(arr,@carousel,1,0,[],3)
                @party.heroes_array << hero_instance 
                @carousel.delete(hero_instance)
            else 
            end
                @text_log.write("Your party is full!")
            when "Refresh"
                refresh_carousel
            when "Back"
                not_done = false
            end
        end
    end

    def dismiss_member_loop
        not_done = true
        while not_done == true
            display("View Party")
            input = Menu.start(["Dismiss","Back"],["Dismiss","Back"],Curses.lines-6,1)
            case input
            when "Dismiss"
                arr =[]
                @party.heroes_array.length.times do
                    arr << ""
                end
                hero_instance = Menu.start(arr,@party.heroes_array,1,0,[],3)
                @party.heroes_array.delete(hero_instance)
            when "Back"
                not_done = false
            end
        end
    end

    def display(string="")
        Curses.clear
        @party.standard_menu_display
        case string
        when "Hire Member"
            display_adventurers(@carousel)
        when "View Party"
            display_adventurers(@party.heroes_array)
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

    def display_adventurers(array)
        start_display_line = 1
        array.length.times do  |counter|
            Curses.setpos(start_display_line+counter*3,5)
            Curses.addstr " #{array[counter].name}"
            Curses.setpos(start_display_line+counter*3,17) 
            Curses.addstr " #{array[counter].job}"
            Curses.setpos(start_display_line+counter*3,27)
            Curses.addstr"HP: #{array[counter].current_HP} / #{array[counter].max_HP}"
            Curses.setpos(start_display_line+counter*3,41)
            Curses.addstr"MP: #{array[counter].current_MP} / #{array[counter].max_MP}"
            Curses.setpos(start_display_line+counter*3,55)
            Curses.addstr"ATK: #{array[counter].atk}"
            Curses.setpos(start_display_line+counter*3,64)
            Curses.addstr"DEF: #{array[counter].defense}"
            Curses.setpos(start_display_line+counter*3+1,10)
            Curses.addstr"#{array[counter].skill1.action_name}: #{array[counter].skill1.description}"
            Curses.setpos(start_display_line+counter*3+2,10)
            Curses.addstr"#{array[counter].skill2.action_name}: #{array[counter].skill2.description}"
        end
    end

    def fill_carousel
        4.times do 
           @carousel <<  Adventurer.generate_new_adventurer_with_job
        end
    end

    def refresh_carousel
        if  @party.money >= 5
            @party.money = @party.money - 5
            @carousel = []
            fill_carousel
        end
    end
        
end
    