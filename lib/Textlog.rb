class Text_Log

    def initialize(max_size = 13)
        @lines_of_Text = []
        @relevant_lines = 0
        @max_size = max_size
        @max_size.times do
            @lines_of_Text << ""
        end
    end


    def write(message)
        if message.class == String
               @lines_of_Text.unshift(message)
               @relevant_lines = 1
        elsif message.class == Array
            message.each do |string|
               @lines_of_Text.unshift(string)
               @relevant_lines = message.length
            end
        end
        
        while @lines_of_Text.length > @max_size
            @lines_of_Text.pop
        end
    end

    def display_text(start_y, start_x)
        @lines_of_Text.length.times do |i|
            Curses.setpos(start_y - i, start_x)
            if i >= @relevant_lines
                Curses.attrset(Curses.color_pair(1))
            end
            Curses.addstr(@lines_of_Text[i])
        end
    end

end