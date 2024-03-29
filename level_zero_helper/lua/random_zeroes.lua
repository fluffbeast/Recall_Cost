<< 
local num_zeroes = wesnoth.get_variable "Recall_Zero_Number_Random_Units"
local cost_choice = wesnoth.get_variable "Recall_Zero_cost_choice"

local extra_units = wesnoth.get_variable "Recall_Zero_Enable_Extra_Types"
local recall_list_done = wesnoth.get_variable "Recall_Cost_Done"
local gimme_more = wesnoth.get_variable "Recall_Zero_More_After_Every_Scenario"
local enable_wol = wesnoth.get_variable "Recall_Zero_Enable_WoL"

local sides = wesnoth.get_sides({ {"has_unit", { canrecruit = true }} })

local settings = ""
if num_zeroes and not recall_list_done then
    settings = settings .. ", with " .. num_zeroes .. " units added to recall list | "
    if extra_units then settings = settings .. "with custom unit types | " end
    if gimme_more then settings = settings .. "and more after every scenario | " end
end
if settings ~= "" then wesnoth.message("Level Zero Helper Mod",settings) end

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

    -- From Default_L0_Era
    "LZH Dark Initiate",
    "LZH Walking Skeleton",
    "LZH Soul",
    "LZH Dwarvish Woodcutter",
    "LZH Dwarvish Miner",
    "LZH Elvish Horseman",
    "LZH Elvish Citizen",
    "LZH Elvish Healer",
    "LZH Merman Citizen",
    "LZH Nobleman",
    "LZH Squire",
    "LZH Pilferer",
    "LZH Initiate",
}

local wol_zeroes = {
    -- From War_of_Legends
    "Cave Wyrmlet",
    "Sky Shard",
    -- "Brazier Whelpling", (not in Multiplayer)
    "Fire Wisp",
    "Wisp",
    "Bloodborn",
    "Lesser Wisp",
    "Quenoth Dustbok",
}


local trainee_male_advance = {}
local trainee_female_advance = {}

if extra_units then
    local trainee_weight = #zero_units / 4
    if enable_wol then
        trainee_weight = trainee_weight + 2
        for i=1, #wol_zeroes, 1 do
            table.insert(zero_units, wol_zeroes[i])
        end
    end
    for i=1, trainee_weight, 1 do  -- Make Trainee Mage more common
        table.insert(zero_units, "LZH_Trainee_Mage")
    end
    -- table.insert(zero_units, "Beardless_Dwarf")
    -- table.insert(zero_units, "Saurian_Eft")
    -- table.insert(zero_units, "Drakelet")

    trainee_male_advance = { "Mage", "Dark Adept", "Dune Burner",
                                   "Dune Herbalist","Saurian Augur", }
    trainee_female_advance = { "Mage", "Dark Adept", "Dune Burner",
                                     "Elvish Shaman","Mermaid Initiate", }

    wol_extra = {
        "Blood Apprentice",
        "Minotaur Shaman",
        "Orcish Shaman",
        "Necro Initiate",
    }

    wol_extra_m = {
        "Thunder Mage",
        "Legion Medic",
        "Shaman",
        "Shadow Initiate",
    }

    wol_extra_f = {
        "Lightborn",
        "Priestess of the Vault",
        "Adept of Light",
        "Wood Mage",
        "Aragwaith Adept",
        "Faerie Sprite",
        "Elvish Acolyte",
        "Scribe",
        "Weaver",
    }
    if enable_wol then
        for i=1, #wol_extra, 1 do
            table.insert(trainee_male_advance, wol_extra[i])
            table.insert(trainee_female_advance, wol_extra[i])
        end
        for i=1, #wol_extra_m, 1 do
            table.insert(trainee_male_advance, wol_extra_m[i])
        end
        for i=1, #wol_extra_f, 1 do
            table.insert(trainee_female_advance, wol_extra_f[i])
        end
    end
end

if not recall_list_done or gimme_more then
    for side_index, side in ipairs(sides) do
        if side.controller == 'human' then
            for i=1, num_zeroes, 1 do
                local u = wesnoth.create_unit {type=mathx.random_choice(zero_units), random_gender="yes"}
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
