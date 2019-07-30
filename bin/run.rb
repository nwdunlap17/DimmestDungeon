require_relative('environment.rb')


hero = Combatant.new(4,2,10)
slime = Combatant.new(4,1,10)

heros = [hero]
monsters = [slime]

CombatManager.new(heros,monsters)

