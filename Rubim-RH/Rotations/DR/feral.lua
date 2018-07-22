---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Rubim.
--- DateTime: 21/06/2018 01:23
---

--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local RubimRH = LibStub("AceAddon-3.0"):GetAddon("RubimRH")
local addonName, addonTable = ...;
-- HeroLib
local HL = HeroLib;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;
--- ============================ CONTENT ============================
-- Spells
if not Spell.Druid then
    Spell.Druid = {};
end
Spell.Druid.Feral = {
    -- Racials
    Berserking = Spell(26297),
    Shadowmeld = Spell(58984),
    -- Abilities
    Berserk = Spell(106951),
    FerociousBite = Spell(22568),
    Maim = Spell(22570),
    MoonfireCat = Spell(155625),
    PredatorySwiftness = Spell(69369),
    Prowl = Spell(5215),
    ProwlJungleStalker = Spell(102547),
    Rake = Spell(1822),
    RakeDebuff = Spell(155722),
    Rip = Spell(1079),
    Shred = Spell(5221),
    Swipe = Spell(106785),
    Thrash = Spell(106830),
    TigersFury = Spell(5217),
    WildCharge = Spell(49376),
    -- Talents
    BalanceAffinity = Spell(197488),
    Bloodtalons = Spell(155672),
    BloodtalonsBuff = Spell(145152),
    BrutalSlash = Spell(202028),
    ElunesGuidance = Spell(202060),
    GuardianAffinity = Spell(217615),
    Incarnation = Spell(102543),
    JungleStalker = Spell(252071),
    JaggedWounds = Spell(202032),
    LunarInspiration = Spell(155580),
    RestorationAffinity = Spell(197492),
    Sabertooth = Spell(202031),
    SavageRoar = Spell(52610),
    MomentOfClarity = Spell(236068),
    SavageRoar = Spell(52610),
    FeralFrenzy = Spell(274837),
    -- Artifact
    AshamanesFrenzy = Spell(210722),
    -- Defensive
    Regrowth = Spell(8936),
    Renewal = Spell(108238),
    SurvivalInstincts = Spell(61336),
    -- Utility
    SkullBash = Spell(106839),
    -- Shapeshift
    BearForm = Spell(5487),
    CatForm = Spell(768),
    MoonkinForm = Spell(197625),
    TravelForm = Spell(783),
    -- Legendaries
    FieryRedMaimers = Spell(236757),
    -- Tier Set
    ApexPredator = Spell(252752), -- TODO: Verify T21 4-Piece Buff SpellID
    -- Misc
    RipAndTear = Spell(203242),
    Clearcasting = Spell(135700),

};
local S = Spell.Druid.Feral;
S.Rip:RegisterPMultiplier({ S.BloodtalonsBuff, 1.2 }, { S.SavageRoar, 1.15 }, { S.TigersFury, 1.15 });
--S.Thrash:RegisterPMultiplier({S.BloodtalonsBuff, 1.2}, {S.SavageRoar, 1.15}, {S.TigersFury, 1.15}); Don't need it but add moment of clarity scaling if we add it
S.Rake:RegisterPMultiplier(
        S.RakeDebuff,
        { function()
            return Player:IsStealthed(true, true) and 2 or 1;
        end },
        { S.BloodtalonsBuff, 1.2 }, { S.SavageRoar, 1.15 }, { S.TigersFury, 1.15 }
);

-- Items
if not Item.Druid then
    Item.Druid = {};
end
Item.Druid.Feral = {
    -- Legendaries
    LuffaWrappings = Item(137056, { 9 }),
    AiluroPouncers = Item(137024, { 8 })
};
local I = Item.Druid.Feral;

local function APL()

    if not Player:AffectingCombat() then
        return 0, 462338
    end
    HL.GetEnemies("Melee");
    HL.GetEnemies(8, true);
    HL.GetEnemies(10, true);



    if S.Berserk:IsReady("Melee") and RubimRH.CDsON() and Cache.EnemiesCount[8] >= 1 then
        return S.Berserk:Cast()
    end

    if S.TigersFury:IsReady("Melee") and Player:EnergyPredicted() <= 45 and Cache.EnemiesCount[8] >= 1 then
        return S.TigersFury:Cast()
    end

    if S.Regrowth:IsReady() and S.Bloodtalons:IsAvailable() and not Player:Buff(S.BloodtalonsBuff) then
        return S.Regrowth:Cast()
    end

    if S.TigersFury:IsReady("Melee") and Player:EnergyPredicted() <= 30 then
        return S.TigersFury:Cast()
    end

    if S.FeralFrenzy:IsReady("Melee") and Player:ComboPoints() == 0 then
        return S.FeralFrenzy:Cast()
    end

    if S.Sabertooth:IsAvailable() then
        if S.FerociousBite:IsReady("Melee") and Target:DebuffRemains(S.Rip) >= 3 then
            return S.FerociousBite:Cast()
        end
    else
        if S.Rip:IsReady("Melee") and Target:DebuffRemains(S.Rip) <= 3 and Target:Exists() and Target:HealthPercentage() > 25 then
            return S.Rip:Cast()
        end

        if S.FerociousBite:IsReady("Melee") and Target:DebuffRemains(S.Rip) <= 3 and Target:Exists() and Target:HealthPercentage() < 25 then
            return S.FerociousBite:Cast()
        end
    end

    if Cache.EnemiesCount[8] >= 3 and S.Thrash:IsReady() and Target:DebuffRemains(S.Thrash) < 3 then
        return S.Thrash:Cast()
    end

    if S.Rip:IsReady("Melee") and Target:DebuffRemains(S.Rip) <= 3 then
        return S.Rip:Cast()
    end

    if S.Rake:IsReady("Melee") and Target:DebuffRemains(S.RakeDebuff) <= 3 then
        return S.Rake:Cast()
    end

    if S.SavageRoar:IsReady("Melee") and Player:BuffRemains(S.SavageRoar) <= 3 then
        return S.SavageRoar:Cast()
    end

    if S.MoonfireCat:IsReady("Melee") and S.LunarInspiration:IsAvailable() then
        return S.MoonfireCat:Cast()
    end

    if S.FerociousBite:IsReady("Melee") and Player:ComboPoints() == 5 and Player:BuffRemains(S.ApexPredator) > 0 then
        return S.FerociousBite:Cast()
    end

    if S.Thrash:IsReady("Melee") and I.LuffaWrappings:IsEquipped() and Target:DebuffRemains(S.Thrash) <= 3 and Player:Buff(S.Clearcasting) then
        return S.Thrash:Cast()
    end

    if S.FerociousBite:IsReady("Melee") and Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) >= 7 and S.SavageRoar:IsAvailable() and Target:DebuffRemains(S.Rip) >= 7 then
        return S.FerociousBite:Cast()
    end

    if S.FerociousBite:IsReady("Melee") and Player:ComboPoints() == 5 and not S.SavageRoar:IsAvailable() and Target:DebuffRemains(S.Rip) >= 7 then
        return S.FerociousBite:Cast()
    end

    if S.BrutalSlash:IsReady("Melee") and Player:ComboPoints() < 5 then
        return S.BrutalSlash:Cast()
    end

    if S.Shred:IsReady("Melee") then
        return S.Shred:Cast()
    end

    return 0, 975743
end
RubimRH.Rotation.SetAPL(103, APL);

local function PASSIVE()
    return RubimRH.Shared()
end

RubimRH.Rotation.SetPASSIVE(103, PASSIVE);