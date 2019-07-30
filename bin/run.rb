require_relative('environment.rb')


hero = Adventurer.new(4,2,10)
slime = Monster.new(4,1,100)
slime.name = "Slime"
boblin = Monster.new(4,1,100)
boblin.name = "Boblin"

heros = [hero]
monsters = [slime,boblin]

CombatManager.new(heros,monsters)

