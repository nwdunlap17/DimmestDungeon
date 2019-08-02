def start_screen
##Drawing goes here

Curses.setpos(Curses.lines-1,(Curses.cols/2)-12)
Curses.addstr("Press any key to begin...")
Curses.getch
end