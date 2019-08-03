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
        tavern_quotes = ["Your party stumbles into the Tavern after a hard day of work.","The tavern keep greets you all with a somber grimace."]
        @text_log.write(tavern_quotes.sample)
        still_in_town = true
        while still_in_town
            display
            choices = ["Hire Member","View Party","To Dungeon","Heal Party","Quit Game"]
            input = Menu.start(choices,choices,Curses.lines-6,1,["After a few ales, anyone almost would join your party.","Take a look at the sorry lot you've gathered.","Nobody will find loot laying around all day.", "Nothing like a good brew to warm your bellies! Costs 25 coin.","Done for the day?"])
            case input
            when "Hire Member"
                if @party.heroes_array.length < 4
                    recruit_member_loop
                else 
                    @text_log.write("Your party is full!")
                end
            when "View Party"
                display(input)
                view_party_loop
            when "Heal Party"
                if @party.money >= 25
                    @party.money -= 25
                    @text_log.write("A few hearty drinks and your wounds and spirits are recovered!")
                    @party.heroes_array.each do |party_member|
                        party_member.current_HP = party_member.max_HP
                        party_member.current_MP = party_member.max_MP
                    end
                else
                    @text_log.write("You realize that you are too poor to addle your mind.")
                end
            when "To Dungeon"
                if @party.heroes_array.length >= 1
                    still_in_town = false
                    @text_log.write("You enter the dungeon...")
                else 
                    @text_log.write("Foolish of you, to wish to journey without adventurers!")
                end
            when "Quit Game"
                exit
            end
        end
    end

    def recruit_member_loop
        not_done = true
        while not_done == true
            display("Hire Member")
            input = Menu.start(["Recruit","Refresh","Back"],["Recruit","Refresh","Back"],Curses.lines-6,1,["Hire one of these fools. Costs 5 coin.","Bring in a new lot. Costs 5 coin.",""])
            case input
            when "Recruit"
                if @party.heroes_array.length < 4 && @party.money >= 5
                arr =[]
                    @carousel.length.times do
                    arr << ""
                    end
                    hero_instance = Menu.start(arr,@carousel,1,0,[],3)
                    @party.heroes_array << hero_instance 
                    @party.money -= 5
                    @carousel.delete(hero_instance)
                else 
                    @text_log.write("Your party is full!")
                end
            when "Refresh"
                refresh_carousel
            when "Back"
                not_done = false
            end
        end
    end

    def view_party_loop
        not_done = true
        while not_done == true
            display("View Party")
            input = Menu.start(["Magic Items","Dismiss","Back"],["Magic Items","Dismiss","Back"],Curses.lines-6,1,["View equipped items","Not very fond of them, yea? Send them on their way."])
            case input
            when "Magic Items"
                arr =[]
                @party.heroes_array.length.times do
                    arr << ""
                end
                hero_instance = Menu.start(arr,@party.heroes_array,1,0,[],3)
                owned_treasure = hero_instance.treasures
                if owned_treasure.length == 0
                    array = ["#{hero_instance.name} has no magic items."]
                else
                    array = owned_treasure.map{|treas| "#{treas.name}: #{treas.description}"}
                    array.unshift("#{hero_instance.name} has equipped the following magic items:")
                end
                display_treasures(array)
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
        Curses.setpos(0,76)
        Curses.addstr "Location: Tavern"
        Curses.setpos(1,76)
        Curses.addstr "Coins: #{@party.money}"
        case string
        when "Hire Member"
            display_adventurers(@carousel)
        when "View Party"
            display_adventurers(@party.heroes_array)
        when ""
            @text_log.display_text
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
        Curses.setpos(1,76)
        Curses.addstr"Coins: #{@party.money}"
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
        already_in_use = []
        @party.heroes_array.each do |hero|
            already_in_use << hero
        end
        4.times do 
           hero = Adventurer.get_random_adventurer(already_in_use)
           @carousel <<  hero
           already_in_use << hero
        end
    end

    def refresh_carousel
        if  @party.money >= 5
            carousel.each do |adventurer|
                adventurer.delete
            end
            @party.money = @party.money - 5
            @carousel = []
            fill_carousel
        end
    end   

    def display_treasures(treasures)
        display = 0
        treasure_log = Text_Log.new 
        while display < treasures.length
            Curses.clear
            @party.standard_menu_display
            8.times do |index|
                index = display + index
                if index < treasures.length
                    treasure_log.write("#{treasures[index]}")
                end
            end
            treasure_log.display_text
            Curses.refresh
            Curses.getch
            display += 8
        end
    end
end
    