class Action < ActiveRecord::Base
    #attr_accessor :selection_type, :target_self, :mp_cost, :action_name
    #attr_accessor :damage_multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change, :stun_chance
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    def Action.basic_attack
        return Action.make_attack("none","Attack",false,1,0)
    end

    def Action.make_attack(job,name,targets_all,damage_multiplier,stun)
        skill = Action.new
        skill.job = job
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

    def Action.make_buff(job,name,target,atk,defense,heal,aggro)
        skill = Action.new
        skill.job = job
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

    def Action.make_buffing_attack(job,name,damage_multiplier,stun,atk,defense,heal,aggro)
        skill = Action.new
        skill.job = job
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
        skill = Action.make_attack("Mage","Fireball",true,1,0)
        skill.save
        skill = Action.make_attack("Mage","Death",false,3,0)
        skill.save
        skill = Action.make_attack("Mage","Flash",false,0,0.4)
        skill.save
        skill = Action.make_buff("Mage","Vanish","self",0,0,0,-1)
        skill.save
        skill = Action.make_buff("Mage","Shield","self",0,1,0,0)
        skill.save

        skill = Action.make_attack("Fighter","Strike",false,3,0)
        skill.save
        skill = Action.make_attack("Fighter","Wallop",false,1,0.8)
        skill.save
        skill = Action.make_buff("Fighter","Bulk Up","self",0.5,0.5,0,0)
        skill.save
        skill = Action.make_buff("Fighter","Taunt","self",0,0,0,2)
        skill.save
        skill = Action.make_buffing_attack("Fighter","Rally",1,0,0,0,0.2,0)
        skill.save
        skill = Action.make_buffing_attack("Fighter","Charge!",1.5,0,0.5,0,0,0)
        skill.save

        skill = Action.make_buff("Cleric","Protect","all",0,0.5,0,0)
        skill.save
        skill = Action.make_buff("Cleric","Heal","one",0,0,0.6,0)
        skill.save
        skill = Action.make_buff("Cleric","Bless","all",0.5,0,0,0)
        skill.save
        skill = Action.make_buff("Cleric","Mass Heal","all",0,0,0.2,0)
        skill.save
        skill = Action.make_buffing_attack("Cleric","Smite",2,0,0,0,0.2,0)
        skill.save
    end


end