class CreateOwnerships < ActiveRecord::Migration[5.2]
  def change
    create_table :ownerships do |t|
      t.integer :adventurer_id
      t.integer :treasure_id
    end
  end
end
