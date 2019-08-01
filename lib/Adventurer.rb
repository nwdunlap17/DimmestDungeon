class Adventurer < ActiveRecord::Base
    has_many :treasures
    has_many :monsters, through: :treasures
    attr_accessor :current_MP, :skill1, :skill2

    include Combatant


    def get_ready_for_combat   
        super
        current_MP = max_MP
    end

    def full_heal
        current_HP = max_HP
        current_MP = max_MP
    end

    def self.manual_generation(name = "",attack=4,defense=0,max_HP=50,max_MP=10)
        hero = Adventurer.new
        hero.atk = attack
        hero.defense = defense
        hero.max_HP = max_HP
        hero.name = name
        hero.job = "none"
        hero.max_MP = max_MP
        hero.current_MP = max_MP
        hero.current_HP = hero.max_HP
        hero.reset_buffs
        if name == ""
            api_response = RestClient.get("https://randomuser.me/api/")
            parsed = JSON.parse(api_response.body)
            hero.name = parsed["results"][0]["name"]["first"].capitalize
        else
            hero.name = name
        end
        return hero
    end

    def self.generate_new_adventurer_with_job
        randjob = rand(3)
        case randjob
        when 0
            hero = Adventurer.make_fighter
        when 1
            hero = Adventurer.make_cleric
        when 2
            hero = Adventurer.make_mage
        end
        4.times do 
            hero.random_stat_up
        end
        hero.get_ready_for_combat
        hero.save
        return hero
    end

    def self.make_fighter
        hero = Adventurer.manual_generation("",4,3,60,10)
        hero.job = "Fighter"
        skill_array = Action.where(job: "Fighter")
        rand1 = rand(skill_array.length)
        rand2 = rand1
        while rand1 == rand2
            rand2 = rand(skill_array.length)
        end
        hero.skill1 = skill_array[rand1]
        hero.skill1_id = skill_array[rand1].id
        hero.skill2 = skill_array[rand2]
        hero.skill2_id = skill_array[rand2].id
        return hero
    end
    def self.make_cleric
        hero = Adventurer.manual_generation("",2,4,50,15)
        hero.job = "Cleric"
        skill_array = Action.where(job: "Cleric")
        rand1 = rand(skill_array.length)
        rand2 = rand1
        while rand1 == rand2
            rand2 = rand(skill_array.length)
        end
        hero.skill1 = skill_array[rand1]
        hero.skill1_id = skill_array[rand1].id
        hero.skill2 = skill_array[rand2]
        hero.skill2_id = skill_array[rand2].id
        return hero
    end
    def self.make_mage
        hero = Adventurer.manual_generation("",3,1,40,20)
        hero.job = "Mage"
        skill_array = Action.where(job: "Mage")
        rand1 = rand(skill_array.length)
        rand2 = rand1
        while rand1 == rand2
            rand2 = rand(skill_array.length)
        end
        hero.skill1 = skill_array[rand1]
        hero.skill1_id = skill_array[rand1].id
        hero.skill2 = skill_array[rand2]
        hero.skill2_id = skill_array[rand2].id
        return hero
    end

    def random_stat_up
        randval = rand(4)
        case randval
        when 0
            self.atk += 1
        when 1
            self.defense += 1
        when 2
            self.max_HP += 5
        when 3
            self.max_MP += 2
        end
    end
end