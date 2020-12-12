class Stats
    def initialize(damage=0, health=0, defense=0, effectiveHp=0, strength=0, damageIncrease=0, speed=0, critChance=0, critDamage=0, bonusAttackSpeed=0, intelligence=0, seaCreatureChance=0, magicFind=0, petLuck)
        @damage = damage
        @health = health
        @defense = defense
        @effectiveHp = effectiveHp
        @strength = strength
        @damageIncrease = damageIncrease
        @speed = speed
        @critChance = critChance
        @critDamage = critDamage
        @bonusAttackSpeed = bonusAttackSpeed
        @intelligence = intelligence
        @seaCreatureChance = seaCreatureChance
        @magicFind = magicFind
        @petLuck = petLuck
    end

    attr_accessor :damage
    attr_accessor :health
    attr_accessor :defense
    attr_accessor :effectiveHp
    attr_accessor :strength
    attr_accessor :damageIncrease
    attr_accessor :speed
    attr_accessor :critChance
    attr_accessor :critDamage
    attr_accessor :bonusAttackSpeed
    attr_accessor :intelligence
    attr_accessor :seaCreatureChance
    attr_accessor :magicFind
    attr_accessor :petLuck
end

def getDefaultStats()
    new Stats(damage=0, health=100, defense=0, effectiveHp=100, strength=0, damageIncrease=0, speed=100, critChance=30, critDamage=50, bonusAttackSpeed=0, intelligence=0, seaCreatureChance=20, magicFind=10, petLuck=0)
end

def calculateFairySoulBonus(exchangeCount)
    bonus = new Stats(speed=exchangeCount/10)

    (0...exchangeCount).each do |idx|
        bonus[:strength] += (idx + 1) % 5 == 0 ? 2 : 1
        bonus[:defense] += (idx + 1) % 5 == 0 ? 2 : 1
        bonus[:health] += 3 + idx/2
    end
    bonus
end