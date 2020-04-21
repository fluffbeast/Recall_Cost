<< 
local num_zeroes = wesnoth.get_variable "Recall_Zero_Number_Random_Units"
local cost = wesnoth.get_variable "Recall_Zero_cost"
local change_recall_cost = wesnoth.get_variable "Change_Zero_Recall"
local helper = wesnoth.require("lua/helper.lua")

local sides = wesnoth.get_sides({ {"has_unit", { canrecruit = true }} })

local extra_units = wesnoth.get_variable "Recall_Zero_Enable_Extra_Types"

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
}
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.15.1") then
    table.insert(zero_units, "Wose Sapling")
end
if extra_units then
    table.insert(zero_units, "Trainee Mage")
    -- zero_units.insert("Saurian Eft")
    -- zero_units.insert("Drakelet")
end

local trainee_male_advance = { "Mage", "Dark Adept" }
local trainee_female_advance = { "Mage", "Dark Adept" }

local trainee_male_options = {
    "Dune Burner","Dune Herbalist","Saurian Augur",
    -- "Thunder Mage", "Shaman",
}
local trainee_female_options = {
    "Dune Burner","Elvish Shaman","Mermaid Initiate",
    -- "Aragwaith Adept", "Southern Mystic", "Elvish Acolyte", "Faerie Sprite",
    -- "Adept of Light", "Wood Mage",
}

for _, option in ipairs(trainee_male_options) do
    table.insert(trainee_male_advance, option)
end
for _, option in ipairs(trainee_female_options) do
    table.insert(trainee_female_advance, option)
end

local recall_list_done = wesnoth.get_variable "Recall_Cost_Done"
local gimme_more = wesnoth.get_variable "Recall_Zero_More_After_Every_Scenario"

if not recall_list_done or gimme_more then
    for side_index, side in ipairs(sides) do
        if side.controller == 'human' then
            for i=1, num_zeroes, 1 do
                local u = wesnoth.create_unit {type=helper.rand(zero_units), random_gender="yes"}
                if change_recall_cost then
                    u.recall_cost = cost
                end
                -- Should this be done for all created units?
                if u.type == "Trainee Mage" then
                    -- pick an advancement randomly, and make it this unit's destiny.
                    if u.gender == "male" then
                        local r = wesnoth.random ( 1, #trainee_male_advance )
                        local destiny = trainee_male_advance[r]
                        u.advances_to = {destiny}
                    else
                        local r = wesnoth.random ( 1, #trainee_female_advance )
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
