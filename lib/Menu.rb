class Menu
    # Takes in an array of strings (choices)
    # Takes in an equally size array of anything (values)
    # When a choice is made, the corresponding value is returned
    # Takes in starting y and x positions for upper left corner of menu

    def Menu.start(choices, values, y = 15, x = 0)
        menu = Menu.new(choices, values, y, x)
        return menu.menu_loop
    end

    def initialize(choices, values, y = 15, x = 0)
        @choices = choices
        @values = values
        @y = y+1
        @x = x
        @index = 0
        @done = false
        @num_choices = choices.length
    end

    def menu_loop
        choice = nil
        while !!!choice
            display
            input = Curses.getch
            case input
            when "s"#Curses::Key::DOWN
                @index += 1
                if @index == @num_choices
                    @index = 0
                end
            when "w"#Curses::Key::UP
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
            Curses.setpos(@y+i,@x)
            Curses.addstr("    #{@choices[i]}")
        end

        Curses.setpos(@y+@index,@x)
        Curses.addstr("-->")
        
        Curses.refresh
    end
end