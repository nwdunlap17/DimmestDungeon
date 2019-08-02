
require_relative('environment.rb')
# binding.pry
# ExplorationLoop.new
Curses.stdscr.keypad = true
ActiveRecord::Base.logger.level = 1

start_screen
ExplorationLoop.new
