class Action
    attr_accessor :selection_type, :target_self
    attr_accessor :Damage_Multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    def initialize
        @selection_type = "none"
        @Damage_Multiplier = 0
        @target_self = false
        @atk_buff = 0
        @def_buff = 0
        @heal_value = 0
        @aggro_change = 0
    end

    def Action.basic_attack
        skill = Action.new
        skill.selection_type = "1 Enemy"
        skill.Damage_Multiplier = 1
        skill.target_self = false
        skill.atk_buff = 0
        skill.def_buff = 0
        skill.heal_value = 0
        skill.aggro_change = 0
        return skill
    end
end