
require_relative('environment.rb')

Action.Load_Action_List

slime = Monster.manual_generation("Slime",4,0,20)
boblin = Monster.manual_generation("Boblin",2,2,20)

monsters = [slime,boblin]