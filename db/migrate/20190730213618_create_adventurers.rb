class CreateAdventurers < ActiveRecord::Migration[5.2]
  def change
    create_table :adventurers do |a|
      a.string :name
      a.string :from
      a.integer :atk
      a.integer :def
      a.integer :max_HP
    end
  end
end
