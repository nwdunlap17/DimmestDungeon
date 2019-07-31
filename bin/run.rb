
require_relative('environment.rb')

# Action.Load_Action_List
# Monster.load_monsters

#banana = Room.new(10)
slime = Monster.manual_generation("Slime",4,0,20)
boblin = Monster.manual_generation("Boblin",2,2,20)

monsters = [slime,boblin]

nick = Adventurer.manual_generation("Nick",2,4,10)
katana = Adventurer.manual_generation("Katana",10,10,20)

heros = [nick,katana]
CombatManager.new(heros,monsters)