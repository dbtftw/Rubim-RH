---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rubim.
--- DateTime: 14/06/2018 10:19
---

local pvpSpells = {
    211714, -- Thal'kiel's Consumption
    157695, -- Demonbolt **
    32375, --Mass Dispel (only if our team mate has bubble/iceblock active) 
    48181, -- Haunt 
    202771, -- Full Moon **
    199786, -- Glacial Spike
    116858, -- Chaos Bolt 
    105174, -- Hand of Gul'dan 
    228260, -- Void Eruption
    34914, -- Vampiric Touch
    124465, -- Vampiric Touch
    30108, -- Unstable Affliction
    214634, -- Ebonbolt
    205495, -- Stormkeeper
}

local pvpDMG = {
    116, --  Frostbolt
    2948, --  Scorch
    51505, --  Lava Burst
    403, --  Lightnin Bolt
    1120, --  Drain Soul
    48181, --  Haunt
    30451, --  Arcane Blast
    113092, --  Frost Bomb
    8092, --  Mind Blast
    11366, --  Pyroblast
    126201, --  Frost Bolt
    15407, --  Mind Flay
    44614, --  Frostfire Bolt
    133, --  Fireball
    103103, --  Malefic Grasp
    117014, --  Elemental Blast
    118297     --  Immolate
}

local pvpHEALING = {
    5185, --  Healing Touch
    8936, --  Regrowth
    50464, --  Nourish
    19750, --  Flash of Light
    82326, --  Divine Light
    2061, --  Flash Heal
    64901, --  Hymn of Hope
    12051, --  Evocation
    64843, --  Divine Hymn
    115175, --  Soothing Mist
    8936, --  Regrowth
    2061, --  Flash Heal
    32546, --  binding Heal
    2060, --  Greater Heal
    2006, --  Resurrection
    5185, --  Healing Touch
    596, --  Prayer of Healing
    19750, --  Flash of Light
    635, --  Holy Light
    7328, --  Redemption
    2008, --  Ancestral Spirit
    50769, --  Revive
    82327, --  Holy Radiance
    82326, --  Divine Light
    740, --  Tranquillity
    116694, --  Surging Mist
    124682, --  Enveloping Mist
    64901, --  Hymn of Hope
    64843, --  Divine Hymn
    115151, --  Renewing Mist
    115310, --  Revival
    152118, --  Clarity of Will
    85673, --  Word of Glory
    152116, --  Saving Grace
    186263  --  Shadow Mend
}

local pvpHEX = {
    5782, --  Fear
    33786, --  Cyclone
    28272, --  Pig Poly (if we have a resto Druid team mate check if out of form)
    118, --  Sheep Poly (same as above ^^)
    61305, --  Cat Poly (^^)
    61721, --  Rabbit Poly (^^)
    61780, --  Turkey Poly (^^)
    28271, --  Turtle Poly (^^)
    51514, --  Hex (Only kick if we do not have a feral Druid in our team)
    20066, --  Repentance
    82012, --  Repentance
    605, --  Dominate Mind
}

function findHealer()
    for i = 1, 3 do
        local enemyHealer = "None"
        if GetSpecializationRoleByID(GetArenaOpponentSpec(i)) == "HEALER" then
            print("arena" .. i)
            break
        end
    end
end

function ShouldInterrupt()
    local importantCast = false
    local allyHealer = "None"
    local enemyHealer = "None"
    for i = 1, 3 do
        local enemyHealer = "None"
        if GetSpecializationRoleByID(GetArenaOpponentSpec(i)) == "HEALER" then
            enemyHealer = "arena" .. i
            break
        end
    end

    for i = 1, 3 do
        local allyHealer = "None"
        if GetSpecializationRoleByID(GetInspectSpecialization("arena" .. i)) == "HEALER" then
            enemyHealer = "arena" .. i
            break
        end
    end

    local castName1, _, _, _, castStartTime1, castEndTime1, _, _, notInterruptable1, spellID1 = UnitCastingInfo("arena1")
    local castName2, _, _, _, castStartTime2, castEndTime2, _, _, notInterruptable2, spellID2 = UnitCastingInfo("arena2")
    local castName3, _, _, _, castStartTime3, castEndTime3, _, _, notInterruptable3, spellID3 = UnitCastingInfo("arena3")

    if castName == nil then
        local castName1, nameSubtext1, text1, texture, startTimeMS1, endTimeMS1, isTradeSkill, notInterruptible1 = UnitChannelInfo("arena1")
        local castName2, nameSubtext2, text2, texture, startTimeMS2, endTimeMS2, isTradeSkill, notInterruptible2 = UnitChannelInfo("arena2")
        local castName3, nameSubtext3, text3, texture, startTimeMS3, endTimeMS3, isTradeSkill, notInterruptible3 = UnitChannelInfo("arena3")
    end

    if spellID == nil or notInterruptable == true then
        return false
    end

    for i, v in ipairs(pvpHEX) do
        if spellID == v then
            importantCast = true
            break
        end
    end

    if spellID == nil or castInterruptable == false then
        return false
    end

    if int_smart == false then
        importantCast = true
    end

    if importantCast == false then
        return false
    end

    local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
    local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000
    local castTime = castEndTime - castStartTime
    local currentPercent = timeSinceStart / castTime * 100000
    local interruptPercent = math.random(40, 80)
    if currentPercent >= interruptPercent then
        return true
    end
    return false
end

local arenaSTART = CreateFrame("Frame")
arenaSTART:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")

enemyHealer = {}
enemyDPS = {}
arenaSTART:SetScript("OnEvent", function(self, event, ...)
    local numOpps = GetNumArenaOpponentSpecs()
    enemyHealer = {}
    enemyDPS = {}
    for i = 1, numOpps do
        local specID = GetArenaOpponentSpec(i)
        if specID > 0 then
            local id, name, description, icon, role, class = GetSpecializationInfoByID(specID)
            local repeated = 0
            if role == "HEALER" then
                table.insert(enemyHealer, { Unit = "arena" .. i, Class = class })
            else
                table.insert(enemyDPS, { Unit = "arena" .. i, Class = class })

            end
        end

    end
end)