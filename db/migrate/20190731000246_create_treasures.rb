class CreateTreasures < ActiveRecord::Migration[5.2]
  def change
    create_table :treasures do |t|
      t.text :name
      t.integer :max_HP
      t.integer :max_MP
      t.integer :attack
      t.integer :defense
      t.text :description
      t.text :rarity
      t.text :treasure_type
      t.integer :value
    end
  end
end
