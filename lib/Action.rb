class Action < ActiveRecord::Base
    #attr_accessor :selection_type, :target_self, :mp_cost, :action_name
    #attr_accessor :damage_multiplier, :atk_buff, :def_buff, :heal_value, :aggro_change, :stun_chance
    #selection_type = "1 Enemy", "All Enemies", "1 Ally", "All allies"
    #target self

    def Action.basic_attack
        return Action.make_attack("none","Attack",0,false,1,0,"A basic attack.")
    end

    def Action.make_attack(job,name,mp_cost,targets_all,damage_multiplier,stun,description)
        skill = Action.new
        skill.job = job
        skill.mp_cost = mp_cost
        if mp_cost > 0
            description += " Costs #{mp_cost} MP."
        end
        skill.action_name = name
        if targets_all
            skill.selection_type = "All Enemies"
        else
            skill.selection_type = "1 Enemy"
        end
        skill.damage_multiplier = damage_multiplier
        skill.description = description
        skill.stun_chance = stun

        return skill
    end

    def Action.make_buff(job,name,mp_cost,target,atk,defense,heal,aggro,description)
        skill = Action.new
        skill.job = job
        skill.mp_cost = mp_cost
        if mp_cost > 0
            description += " Costs #{mp_cost} MP."
        end
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
        skill.description = description
        skill.aggro_change = aggro
        return skill
    end

    def Action.make_buffing_attack(job,name,mp_cost,damage_multiplier,stun,atk,defense,heal,aggro,description)
        skill = Action.new
        skill.job = job
        skill.mp_cost = mp_cost
        if mp_cost > 0
            description += " Costs #{mp_cost} MP."
        end
        skill.action_name = name
        skill.selection_type = "1 Enemy"
        skill.target_self = true
        skill.damage_multiplier = damage_multiplier
        skill.stun_chance = stun
        skill.atk_buff = atk
        skill.def_buff = defense
        skill.heal_value = heal
        skill.aggro_change = aggro
        skill.description = description
        return skill
    end

    @@Fighter_list = []
    @@Mage_list = []
    @@Cleric_list = []
    def Action.Load_Action_List
        skill = Action.make_attack("Mage","Fireball",2,true,1,0,"Hits all enemies")
        skill.save
        skill = Action.make_attack("Mage","Death",2,false,4,0,"A powerful attack")
        skill.save
        skill = Action.make_attack("Mage","Flash",2,false,0,0.4,"May stun multiple enemies")
        skill.save
        skill = Action.make_buff("Mage","Vanish",2,"self",0,0,0,-1,"Makes the mage less likely to be hit")
        skill.save
        skill = Action.make_buff("Mage","Shield",2,"self",0,1,0,0,"Significantly raises own DEF")
        skill.save

        skill = Action.make_attack("Fighter","Strike",2,false,3,0,"A powerful attack")
        skill.save
        skill = Action.make_attack("Fighter","Wallop",2,false,1,0.8,"An attack that stuns the target")
        skill.save
        skill = Action.make_buff("Fighter","Bulk Up",2,"self",0.5,0.5,0,0,"Raises ATK and DEF")
        skill.save
        skill = Action.make_buff("Fighter","Taunt",2,"self",0,0,0,2,"Makes yourself more likely to be hit")
        skill.save
        skill = Action.make_buffing_attack("Fighter","Rally",2,1,0,0,0,0.2,0,"An attack that heals the user.")
        skill.save
        skill = Action.make_buffing_attack("Fighter","Charge!",2,1.5,0,0.5,0,0,0,"A strong attack that raises ATK.")
        skill.save

        skill = Action.make_buff("Cleric","Protect",2,"all",0,0.5,0,0,"Raises everyone's DEF.")
        skill.save
        skill = Action.make_buff("Cleric","Heal",2,"one",0,0,0.6,0,"Heals one target.")
        skill.save
        skill = Action.make_buff("Cleric","Bless",2,"all",0.5,0,0,0,"Raises everyone's ATK.")
        skill.save
        skill = Action.make_buff("Cleric","Mass Heal",2,"all",0,0,0.2,0,"Heals whole party.")
        skill.save
        skill = Action.make_buffing_attack("Cleric","Smite",2,2,0,0,0,0.2,0,"A strong attack that heals the user.")
        skill.save
    end


end