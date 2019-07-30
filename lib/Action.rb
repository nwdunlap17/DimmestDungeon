class Action
    attr_accessor :selection_type, :target_self, :mp_cost, :action_name
    attr_accessor :damage_Multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    def initialize
        @selection_type = "none"
        @damage_Multiplier = 0
        @mp_cost = 0
        @target_self = false
        @atk_buff = 0
        @def_buff = 0
        @heal_value = 0
        @aggro_change = 0
    end

    def Action.basic_attack
        skill = Action.new
        skill.action_name = "Attack"
        skill.selection_type = "1 Enemy"
        skill.damage_Multiplier = 1
        skill.target_self = false
        skill.atk_buff = 0
        skill.def_buff = 0
        skill.mp_cost = 0
        skill.heal_value = 0
        skill.aggro_change = 0
        return skill
    end

    def Action.make_attack(name,targets_all,damage_Multiplier)
        skill = Action.new
        if targets_all
            skill.selection_type = "All Enemies"
        else
            skill.selection_type = "1 Enemy"
        end
        skill.damage_Multiplier = damage_Multiplier
    end
end