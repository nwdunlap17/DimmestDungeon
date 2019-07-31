class CreateMonsters < ActiveRecord::Migration[5.2]
  def change
    create_table :monsters do |m|
     m.string :name
     m.string :description
     m.integer :atk
     m.integer :defense
     m.integer :max_HP
     m.integer :level

     m.timestamps
    end
  end
end
