class Action
    attr_accessor :selection_type, :target_self, :mp_cost, :action_name
    attr_accessor :damage_Multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change, :stun_chance
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    def initialize(name)
        @action_name = name
        @selection_type = "none"
        @damage_Multiplier = 0
        @mp_cost = 0
        @target_self = false
        @atk_buff = 0
        @def_buff = 0
        @heal_value = 0
        @aggro_change = 0
        @stun_chance = 0
    end

    def Action.basic_attack
        return Action.make_attack("Attack",false,1,0)
    end

    def Action.make_attack(name,targets_all,damage_Multiplier,stun=0)
        skill = Action.new(name)
        if targets_all
            skill.selection_type = "All Enemies"
        else
            skill.selection_type = "1 Enemy"
        end
        skill.damage_Multiplier = damage_Multiplier
        skill.stun_chance = stun
        return skill
    end

    def Action.make_buff(name,target,atk,defense,heal,aggro=0)
        skill = Action.new(name)
        case target
        when "one"
            skill.selection_type = "1 Ally"
        when "all"
            skill.selection_type = "All Allies"
        when "self"
            skill.selection_type = "none"
            skill.target_self = "true"
        end
        skill.atk_buff = atk
        skill.def_buff = defense
        skill.heal_value = heal
        skill.aggro_change = aggro
        return skill
    end

    def Action.make_buffing_attack(name,damage_Multiplier,stun,atk,defense,heal,aggro=0)
        skill = Action.new(name)
        skill.selection_type = "1 Enemy"
        skill.target_self = true
        skill.damage_Multiplier = damage_Multiplier
        skill.stun_chance = stun
        skill.atk_buff = atk
        skill.def_buff = defense
        skill.heal_value = heal
        skill.aggro_change = aggro
        return skill
    end

    @@Fighter_list = []
    @@Mage_list = []
    @@Cleric_list = []
    def Action.Load_Action_List
        @@Mage_list << Action.make_attack("Fireball",true,1)
        @@Mage_list << Action.make_attack("Death",false,3)
        @@Mage_list << Action.make_attack("Flash",false,0,0.4)
        @@Mage_list << Action.make_buff("Vanish","self",0,0,0,-1)
        @@Mage_list << Action.make_buff("Shield","self",0,1,0)

        @@Fighter_list << Action.make_attack("Strike",false,3)
        @@Fighter_list << Action.make_attack("Wallop",false,1,0.8)
        @@Fighter_list << Action.make_buff("Bulk Up","self",0.5,0.5,0)
        @@Fighter_list << Action.make_buff("Taunt","self",0,0,0,2)
        @@Fighter_list << Action.make_buffing_attack("Rally",1,0,0,0,0.2)
        @@Fighter_list << Action.make_buffing_attack("Charge!",1.5,0,0.5,0,0)

        @@Cleric_list << Action.make_buff("Protect","all",0,0.5,0)
        @@Cleric_list << Action.make_buff("Heal","one",0,0,0.6)
        @@Cleric_list << Action.make_buff("Bless","all",0.5,0,0)
        @@Cleric_list << Action.make_buff("Mass Heal","all",0,0,0.2)
        @@Cleric_list << Action.make_buffing_attack("Smite",2,0,0,0,0.2)
    end


end