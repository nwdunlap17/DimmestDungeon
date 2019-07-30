require_relative('environment.rb')

Action.Load_Action_List

hero = Adventurer.new(4,2,10)
hero.name = "Katana"
hero2 = Adventurer.new(2,4,10)
hero2.name = "Nick"
slime = Monster.new(4,1,100)
slime.name = "Slime"
boblin = Monster.new(4,1,100)
boblin.name = "Boblin"

heros = [hero,hero2]
monsters = [slime,boblin]

#Kernel.srand(5)
CombatManager.new(heros,monsters)

