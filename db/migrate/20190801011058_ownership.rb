class Ownership < ActiveRecord::Migration[5.2]
  def change
    create_table :owerships do |t|
      t.integer :adventurer_id
      t.integer :treasure_id
  end
end
