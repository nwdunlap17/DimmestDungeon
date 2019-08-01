
require_relative('environment.rb')

# Action.Load_Action_List
# Monster.load_monsters

Kernel.srand(1)
party = Party.new

monsters_position = []
monsters_position << Monster.new_boss_monster



# slime = Monster.manual_generation("Slime",4,0,20)
# boblin = Monster.manual_generation("Boblin",2,2,20)

# monsters = [slime,boblin]

CombatManager.new(party,monsters_position,Text_Log.new)