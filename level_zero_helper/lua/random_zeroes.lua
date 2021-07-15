<< 
local num_zeroes = wesnoth.get_variable "Recall_Zero_Number_Random_Units"
local cost_choice = wesnoth.get_variable "Recall_Zero_cost_choice"
local helper = wesnoth.require("lua/helper.lua")

local extra_units = wesnoth.get_variable "Recall_Zero_Enable_Extra_Types"
local use_default_l0_era = wesnoth.get_variable "Recall_Zero_Enable_Default_L0_Era"
local use_wol_era = wesnoth.get_variable "Recall_Zero_Enable_WoL_Era"
local recall_list_done = wesnoth.get_variable "Recall_Cost_Done"
local gimme_more = wesnoth.get_variable "Recall_Zero_More_After_Every_Scenario"

local sides = wesnoth.get_sides({ {"has_unit", { canrecruit = true }} })

local settings = ""
if num_zeroes and not recall_list_done then
    settings = settings .. ", with " .. num_zeroes .. " units added to recall list | "
    if extra_units then settings = settings .. "with custom unit types | " end
    if use_default_l0_era then settings = settings .. "with Default L0 Era units | " end
    if gimme_more then settings = settings .. "and more after every scenario | " end
end
if settings ~= "" then wesnoth.message("Level Zero Helper Mod version 0.2.0",settings) end

local zero_units = {
    "Peasant",
    "Woodsman",
    "Goblin Spearman",
    "Vampire Bat",
    "Walking Corpse",
    "Ruffian",
    "Falcon",
    "Giant Scorpling",
    "Giant Rat",
    "Mudcrawler",
    "Icemonax",
    "Frost Stoat",
    "Piglet",
    "Giant Ant",
    "Wose Sapling",
}

local default_l0_era_units = {
    -- From Default_L0_Era
    "Dark Initiate",
    "Walking Skeleton",
    "Soul",
    "Dwarvish Woodcutter",
    "Dwarvish Miner",
    "Elvish Horseman",
    "Elvish Citizen",
    "Elvish Healer",
    "Merman Citizen",
    "Nobleman",
    "Squire",
    "Pilferer",
    "Initiate",
}

local WoL_units = {
    -- From War of Legends era
    -- "Brazier Whelpling",
    "Fire Wisp",
    "Wisp",
    "Quenoth Dustbok",
    "Sky Shard",
    "Bloodborn",
}

if use_default_l0_era then
    for i=1,#default_l0_era_units do
        table.insert(zero_units, default_l0_era_units[i])
    end
end
if use_wol_era then
    for i=1,#WoL_units do
        table.insert(zero_units, WoL_units[i])
    end
end

local trainee_male_advance = {}
local trainee_female_advance = {}

if extra_units then
    local trainee_weight = 2
    if use_default_l0_era then trainee_weight = 5 end
    if use_wol_era then trainee_weight = trainee_weight + 2 end
    for i=1, trainee_weight, 1 do  -- Make Trainee Mage more common
        table.insert(zero_units, "LZH_Trainee_Mage")
    end
    -- table.insert(zero_units, "Beardless_Dwarf")
    -- table.insert(zero_units, "Saurian_Eft")
    -- table.insert(zero_units, "Drakelet")

    trainee_male_advance = { "Mage", "Dark Adept", "Dune Burner",
                                   "Dune Herbalist","Saurian Augur" }
    trainee_female_advance = { "Mage", "Dark Adept", "Dune Burner",
                                     "Elvish Shaman","Mermaid Initiate" }

    if use_wol_era then
        local trainee_male_wol_advance = {
            "Legion Medic",
            "Thunder Mage",
            "Shadow Initiate",
            "Shaman",
            "Minotaur Shaman",
            "Orcish Shaman",
            "Necro Initiate",
            "Blood Apprentice",
        }
        local trainee_female_wol_advance = {
            "Quenoth Mystic",
            "Elvish Acolyte",
            "Faerie Sprite",
            "Aragwaith Adept",
            "Adept of Light",
            "Wood Mage",
            "Scribe",
            -- "Seeker",
            "Weaver",
        }
        for i=1,#trainee_male_wol_advance do
            table.insert(trainee_male_advance, trainee_male_wol_advance[i])
        end
        for i=1,#trainee_female_wol_advance do
            table.insert(trainee_female_advance, trainee_female_wol_advance[i])
        end
    end

end

if not recall_list_done or gimme_more then
    for side_index, side in ipairs(sides) do
        if side.controller == 'human' then
            for i=1, num_zeroes, 1 do
                local u = wesnoth.create_unit {type=helper.rand(zero_units), random_gender="yes"}
                if extra_units and (u.type == "LZH_Trainee_Mage") then
                    -- pick an advancement randomly, and make it this unit's destiny.
                    if u.gender == "male" then
                        local r = mathx.random ( 1, #trainee_male_advance )
                        local destiny = trainee_male_advance[r]
                        u.advances_to = {destiny}
                    else
                        local r = mathx.random ( 1, #trainee_female_advance )
                        local destiny = trainee_female_advance[r]
                        u.advances_to = {destiny}
                    end
                end
                wesnoth.put_recall_unit(u, side.side)
            end
        end
    end
    wesnoth.set_variable("Recall_Cost_Done", true)
end

>>
