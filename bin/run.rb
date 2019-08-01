
require_relative('environment.rb')

# Action.Load_Action_List
# Monster.load_monsters


# Kernel.srand(1)
party1 = Party.new
party1.heroes_array.pop
Tavern.new(party1)

# monsters_position = []
# monsters_position << Monster.new_boss_monster

# slime = Monster.manual_generation("Slime",4,0,20)
# boblin = Monster.manual_generation("Boblin",2,2,20)

# monsters = [slime,boblin]

<<<<<<< HEAD
# CombatManager.new(party,monsters_position,Text_Log.new)

ExplorationLoop.new
=======


#CombatManager.new(Party.new.heroes_array,monsters)

#CombatManager.new(party,monsters_position,Text_Log.new)
>>>>>>> 83ae2808cf252eb579e80a26a172310f94dd0122
