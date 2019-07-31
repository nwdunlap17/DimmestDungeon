class Treasure < ActiveRecord::Base
    belongs_to :adventurer
    belongs_to :monster
end