
require_relative('environment.rb')

Action.destroy_all
Monster.destroy_all
Treasure.destroy_all

Action.Load_Action_List
Monster.load_monsters
Treasure.LoadTreasures