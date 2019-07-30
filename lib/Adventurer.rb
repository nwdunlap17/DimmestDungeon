class Adventurer
    attr_accessor :name, :current_MP, :max_MP, :job

    include Combatant
    def initialize(attack=4,defense=0,max_HP=10)
        super(attack,defense,max_HP)
        @name = "Hero"
        @job = "none"
        @max_MP = 0
        @current_MP = 0
    end

    def generate_new_adventurer_with_job
        
    end

end