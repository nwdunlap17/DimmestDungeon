class Ownership < ActiveRecord::Base
    belongs_to :adventurer
    belongs_to :treasure
end