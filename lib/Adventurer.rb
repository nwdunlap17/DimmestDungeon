class Adventurer < ActiveRecord::Base
    has_many :ownerships
    has_many :treasures, through: :ownerships
    attr_accessor :current_MP, :skill1, :skill2

    include Combatant

    def self.get_random_adventurer(heroes_array)
        if Adventurer.all.length > 25
            acceptable = false
            chosen_hero = nil
            while acceptable == false
                acceptable = true 
                chosen_hero = Adventurer.all.sample
                heroes_array.each do |hero|
                    if chosen_hero == hero
                        acceptable = false
                    end
                end
            end
            chosen_hero.get_ready_for_combat
            chosen_hero.full_heal
            return chosen_hero
        else
            return Adventurer.generate_new_adventurer_with_job
        end
    end

    def get_ready_for_combat   
        self.atk_multi = 1
        self.def_multi = 1
        self.current_HP = max_HP
        self.current_MP = max_MP
        self.skill1 = Action.find_by(id: skill1_id)
        self.skill2 = Action.find_by(id: skill2_id)
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
            hero.name = Adventurer.generate_random_name
        else
            hero.name = name
        end
        return hero
    end

    def self.generate_random_name
        name = nil
        while name == nil
            api_response = RestClient.get("https://randomuser.me/api/")
            parsed = JSON.parse(api_response.body)
            tryname = parsed["results"][0]["name"]["first"]
            tryname.length.times do |index|
                if "abcdefghijklmnopqrstuvwxyz".include?(tryname[index])
                    name = tryname.capitalize
                end
            end
        end
        return name
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
        hero.full_heal
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
            self.current_HP += 5
        when 3
            self.max_MP += 2
            self.current_MP +=2
        end
    end

    def delete
        super
        ownerships = Ownership.where(adventurer_id: self.id)
        ownerships.each do |ownership|
            ownership.delete
        end
    end
end