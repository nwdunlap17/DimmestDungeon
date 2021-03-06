class Menu
    # Takes in an array of strings (choices)
    # Takes in an equally size array of anything (values)
    # When a choice is made, the corresponding value is returned
    # Takes in starting y and x positions for upper left corner of menu

    def Menu.start(choices, values, y = Curses.lines-5, x = 0,descriptions = [],line_multiplier=1)
        menu = Menu.new(choices, values, y, x,descriptions, line_multiplier)
        return menu.menu_loop
    end

    def initialize(choices, values, y = Curses.lines-5, x = 0, descriptions = [],line_multiplier = 1)
        @choices = choices
        @values = values
        @line_multiplier = line_multiplier
        @y = y
        @x = x
        @index = 0
        @done = false
        @num_choices = choices.length
        @descriptions = descriptions
    end

    def menu_loop
        choice = nil
        while !!!choice
            display
            Curses.stdscr.keypad = true
            input = Curses.getch.to_s
            if "SWDJK".include?(input)
                input = input.downcase
            end
            if input == "s" || input == "k" 
                input = "down"
            elsif input == "w" || input == "j"
                input = "up"
            elsif input == "d"
                input = "d"
            end
            case input
            when "down"#Curses::Key::DOWN
                @index += 1
                if @index == @num_choices
                    @index = 0
                end
            when "up" #Curses::Key::UP
                @index -= 1
                if @index == -1
                    @index = @num_choices-1
                end
            when "d"
                choice = @values[@index]
            end
        end
        return choice
    end

    def display
        @num_choices.times do |i|
            Curses.setpos(@y+(i*@line_multiplier),@x)
            Curses.addstr("    #{@choices[i]}")
            #Curses.addstr("    ")
            #Curses.setpos(@y+(i*@line_multiplier),@x+4)
            #Curses.addstr("#{@choices[i]}")
        end
        Curses.setpos(@y+(@index*@line_multiplier),@x)
        Curses.addstr("-->")
        if @descriptions != []
            Curses.setpos(Curses.lines-6,20)
            Curses.addstr" "*(Curses.cols-20)
            Curses.setpos(Curses.lines-6,20)
            Curses.addstr @descriptions[@index]
        end
        Curses.refresh
    end
end