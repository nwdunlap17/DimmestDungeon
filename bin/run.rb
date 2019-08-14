
require_relative('environment.rb')
# ExplorationLoop.new
# binding.pry
# ExplorationLoop.new
Curses.stdscr.keypad = true
ActiveRecord::Base.logger.level = 1
Curses.curs_set(0)

start_screen
ExplorationLoop.new
