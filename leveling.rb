require 'json'

LEVELING_DATA = JSON.parse(File.read("./public/leveling.json"))

def getUserSkillcap(profile)
    skillCap = LEVELING_DATA['skill_cap'].clone
    farmingExtra = profile['jacob2']['perks']['farming_level_cap']
    farmingExtra = 0 if farmingExtra.nil?
    skillCap['farming'] = 50 + farmingExtra unless farmingExtra.nil?
    skillCap
end

def getLevelByXp(xp, skill, skillCap = nil)
    skillCap = LEVELING_DATA['skill_cap'] if skillCap.nil?
    skillTable = (skill == 'runecrafting' or skill == 'dungeon') ? LEVELING_DATA["#{skill}_skill"] : LEVELING_DATA['skill']

    outLevel = {
        :name => skill,
        :xp => xp.to_i,
        :totalXp => xp,
        :level => 0,
        :maxLevel => skillCap[skill],
        :neededXp => 0
    }
    skillTable.each_with_index do |neededXp, idx|
        if outLevel[:xp] < neededXp or idx >= outLevel[:maxLevel] then
            outLevel[:level] = idx
            outLevel[:neededXp] = neededXp
            break
        end
        outLevel[:xp] -= neededXp
    end

    outLevel
end

def eachSkill()
    LEVELING_DATA['skill_cap'].each { |skill| yield skill[0] }
end