
require_relative('environment.rb')

Action.Load_Action_List

Monster.load_monsters

binding.pry
puts "pry does not like to be last"
