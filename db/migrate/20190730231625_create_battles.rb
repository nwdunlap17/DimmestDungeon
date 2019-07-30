class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |b|
      b.integer :user_id
      b.integer :monster_id
    end
  end
end
