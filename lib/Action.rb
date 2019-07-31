class Action < ActiveRecord::Base
    #attr_accessor :selection_type, :target_self, :mp_cost, :action_name
    #attr_accessor :damage_multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change, :stun_chance
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    #def initialize(name)
    #     @action_name = name
    #     @selection_type = "none"
    #     @damage_multiplier = 0
    #     @mp_cost = 0
    #     @target_self = false
    #     @atk_buff = 0
    #     @def_buff = 0
    #     @heal_value = 0
    #     @aggro_change = 0
    #     @stun_chance = 0
    # end

    def Action.basic_attack
        return Action.make_attack("Attack",false,1,0)
    end

    def Action.make_attack(name,targets_all,damage_multiplier,stun=0)
        skill = Action.new
        skill.action_name = name
        if targets_all
            skill.selection_type = "All Enemies"
        else
            skill.selection_type = "1 Enemy"
        end
        skill.damage_multiplier = damage_multiplier
        skill.stun_chance = stun

        return skill
    end

    def Action.make_buff(name,target,atk,defense,heal,aggro=0)
        skill = Action.new
        skill.action_name = name
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

    def Action.make_buffing_attack(name,damage_multiplier,stun,atk,defense,heal,aggro=0)
        skill = Action.new
        skill.action_name = name
        skill.selection_type = "1 Enemy"
        skill.target_self = true
        skill.damage_multiplier = damage_multiplier
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
        skill = Action.make_attack("Fireball",true,1)
        skill.save
        skill = Action.make_attack("Death",false,3)
        skill.save
        skill = Action.make_attack("Flash",false,0,0.4)
        skill.save
        skill = Action.make_buff("Vanish","self",0,0,0,-1)
        skill.save
        skill = Action.make_buff("Shield","self",0,1,0)
        skill.save

        skill = Action.make_attack("Strike",false,3)
        skill.save
        skill = Action.make_attack("Wallop",false,1,0.8)
        skill.save
        skill = Action.make_buff("Bulk Up","self",0.5,0.5,0)
        skill.save
        skill = Action.make_buff("Taunt","self",0,0,0,2)
        skill.save
        skill = Action.make_buffing_attack("Rally",1,0,0,0,0.2)
        skill.save
        skill = Action.make_buffing_attack("Charge!",1.5,0,0.5,0,0)
        skill.save

        skill = Action.make_buff("Protect","all",0,0.5,0)
        skill.save
        skill = Action.make_buff("Heal","one",0,0,0.6)
        skill.save
        skill = Action.make_buff("Bless","all",0.5,0,0)
        skill.save
        skill = Action.make_buff("Mass Heal","all",0,0,0.2)
        skill.save
        skill = Action.make_buffing_attack("Smite",2,0,0,0,0.2)
        skill.save
    end


end