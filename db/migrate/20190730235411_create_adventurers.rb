class CreateAdventurers < ActiveRecord::Migration[5.2]
  def change
    create_table :adventurers do |a|
      a.string :name
      a.string :job
      a.integer :atk
      a.integer :defense
      a.integer :max_HP
      a.integer :max_MP
      a.integer :skill1_id
      a.integer :skill2_id
      a.timestamps
    end
  end
end
