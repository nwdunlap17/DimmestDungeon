class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |a|
      a.text :action_name
      a.text :selection_type
      a.boolean :target_self
      a.integer :mp_cost
      a.decimal :damage_multiplier
      a.decimal :stun_chance
      a.decimal :atk_buff
      a.decimal :def_buff
      a.decimal :heal_value
      a.integer :aggro_change
      a.text :job
    end
  end
end
