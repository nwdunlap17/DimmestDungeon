
require_relative('environment.rb')
# binding.pry

Ownership.destroy_all
Adventurer.destroy_all
start_screen
ExplorationLoop.new
