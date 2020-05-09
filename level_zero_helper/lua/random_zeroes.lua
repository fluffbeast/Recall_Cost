<< 
local num_zeroes = wesnoth.get_variable "Recall_Zero_Number_Random_Units"
local cost = wesnoth.get_variable "Recall_Zero_cost"
local change_recall_cost = wesnoth.get_variable "Change_Zero_Recall"
local helper = wesnoth.require("lua/helper.lua")

local extra_units = wesnoth.get_variable "Recall_Zero_Enable_Extra_Types"
local use_ageless = wesnoth.get_variable "Recall_Zero_Enable_Ageless"
local recall_list_done = wesnoth.get_variable "Recall_Cost_Done"
local gimme_more = wesnoth.get_variable "Recall_Zero_More_After_Every_Scenario"

local sides = wesnoth.get_sides({ {"has_unit", { canrecruit = true }} })

local settings = ""
if change_recall_cost then settings = settings .. "Recall cost for level 0 units is now " .. cost end
if num_zeroes and not recall_list_done then
    settings = settings .. ", with " .. num_zeroes .. " units added to recall list | "
    if extra_units then settings = settings .. "with custom unit types | " end
    if use_ageless then settings = settings .. "with Ageless Era units | " end
    if gimme_more then settings = settings .. "and more after every scenario | " end
end
if settings ~= "" then wesnoth.message("Level Zero Helper Mod version 0.1.4",settings) end

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
if use_ageless then
    zero_units = {
        "Peasant", "Woodsman", "Goblin Spearman", "Vampire Bat",
        "Walking Corpse", "Ruffian", "Falcon", "Giant Scorpling",
        "Giant Rat", "Mudcrawler",
        "AE_mie_vampire_bitten", "AE_mie_leaf_wyvern",
        "AE_mie_thelian_young_wolf", "AE_efm_imperialists_Sapper",
        "AE_efm_whites_Bow_Girl", "AE_efm_dalefolk_Raven",
        -- "AE_efm_pygmies_Toad",
        "AE_efm_pygmies_Knat",
        -- "AE_efm_pygmies_Lizard",
        "AE_bem_anakes_Cursed",
        -- "AE_mag_Drone",
        "AE_mag_Parachutist",
        "AE_mag_Dimensional_Gate", "AE_mag_Magical_Eye", "AE_mag_Mu", "AE_mag_Goblin_Kamikaze",
        "AE_mag_Goblin_Runt", "AE_mag_Black_Orb", "AE_arc_south_seas_Breeze",
        "AE_arc_menagerie_Tower_Ladyboy", "AE_arc_menagerie_Lunar_Bug",
        "AE_arc_menagerie_Scout_Robot", "AE_arc_menagerie_Manbot",
        "AE_arc_menagerie_Lunar_Goo", "AE_arc_khthon_Toad", "AE_arc_khthon_Brown_Duck",
        "AE_arc_khthon_Terrapin", "AE_arc_ukians_Ukian_Civilian",
        "AE_arc_ukians_Ukian_Dog", "AE_arc_ukians_Ukian_Seal",
        "AE_arc_ukians_Royal_Spotter", "AE_arc_despair_Wisp", "AE_arc_phantom_Mummy",
        "AE_arc_phantom_Spirit_Dove", "AE_ext_monsters_Giant_Rat",
        "AE_ext_monsters_Baby_Mudcrawler", "AE_stf_free_saurians_Frozen_Soul",
        "AE_stf_free_saurians_Trainee", "AE_rhy_dr_Slinger",
        "AE_rhy_de_Spiderling", "AE_fut_brungar_Undecided_Student", "AE_ele_Skeletal_Corpse",
        "AE_feu_clockwork_dwarves_Contraption", "AE_chs_aragwaith_Peasant",
        "AE_chs_elementals_Elemental_Wisp", "AE_chs_wild_humans_Wolf", 
        "AE_chs_chaos_empire_Minor_Imp", "AE_mrc_mercenaries_Rookie", "AE_mrc_refugees_Refugee",
        "AE_mrc_Blight_Blob", "AE_mrc_Blight_Infected", "AE_mrc_Blight_Parasite",
        "AE_mrc_Blight_Seeded", "AE_mrc_Blight_Microbe", "AE_mrc_slavers_Hawk",
        "AE_mrc_slavers_Entertainer", "AE_mrc_slavers_Slave", "AE_mrc_oracles_Disciple",
        "AE_mrc_oracles_Scholar", "AE_mrc_infernai_Imp", "AE_mrc_hive_Gnat", "AE_imp_Orcei_Piscator",
        "AE_imp_Orcei_Latronis", "AE_imp_Arendians_Falcon",
        "AE_imp_Lavinians_Auxiliary", "AE_myh_Bloodborn", "AE_myh_Air", "AE_myh_Wolf_Cub",
        "AE_myh_Sky_Shard", "AE_myh_Sneak", "AE_agl_yokai_Pixie",
        "AE_agl_yokai_Weaver_Maiden",
        "AE_agl_yokai_Swarm_Spawn", "AE_agl_yokai_Sproutling", "AE_dep_deep_wisp",
        "AE_agl_steelhive_Lightshifter", "AE_agl_steelhive_Cybercone",
    }
end
local trainee_male_advance = {}
local trainee_female_advance = {}

if extra_units then
    local trainee_weight = 2
    if use_ageless then trainee_weight = 20 end
    for i=1, trainee_weight, 1 do  -- Make Trainee Mage more common
        table.insert(zero_units, "LZH_Trainee_Mage")
    end
    -- table.insert(zero_units, "Beardless Dwarf")
    -- table.insert(zero_units, "Saurian Eft")
    -- table.insert(zero_units, "Drakelet")

    trainee_male_advance = { "Mage", "Dark Adept", "Dune Burner",
                                   "Dune Herbalist","Saurian Augur" }
    trainee_female_advance = { "Mage", "Dark Adept", "Dune Burner",
                                     "Elvish Shaman","Mermaid Initiate" }

    if use_ageless then
        trainee_male_advance = {
            "Mage", "Dark Adept", "Dune Herbalist", "Saurian Augur",
            -- "Dune Burner",
            "Dune Herbalist",
            "Saurian Augur",
            "AE_mie_vampire_apprentice",
            "AE_mie_sylvan_keeper",
            "AE_mie_thelian_spirit", 
            "AE_mie_cornur_shaman",
            "AE_mie_thelian_shaman",
            "AE_efm_highlanders_Witch_Doctor",
            "AE_efm_seastates_Alchemist",
            "AE_efm_dalefolk_Herbalist",
            "AE_efm_dalefolk_Channeler",
            "AE_efm_freemen_Muezzin",
            "AE_efm_freemen_Chanter",
            "AE_bem_anakes_Initiate",
            "AE_bem_wood_warriors_Exiled_Alchemist",
            "AE_mag_Runeadept",
            "AE_mag_Nightmare",
            "AE_mag_DarkApostle",
            "AE_mag_Jinn",
            "AE_mag_Carpet_Rider",
            "AE_mag_Novice_Summoner",
            "AE_mag_Elementalist",
            "AE_mag_Battlemage",
            "AE_mag_Subversive_Mage",
            "AE_mag_Goblin_Shaman",
            "AE_mag_Troll_Sorcerer",
            "AE_mag_Shamanistic_Adept",
            "AE_mag_Disciple",
            "AE_arc_south_seas_Arsonist",
            "AE_arc_menagerie_Blue_Novice",
            "AE_arc_primeval_Primevalist_Follower",
            "AE_arc_phantom_Mummy_Unbound",
            "AE_arc_orcs_Orcish_Drifter",
            "AE_ext_dark_elves_Wizard",
            "AE_ext_outlaws_Rogue_Mage",
            "AE_ext_chaos_Invoker",
            "AE_ext_orcs_Orcish_Shaman",
            "AE_stf_minotaurs_Shaman",
            "AE_stf_free_saurians_Mage",
            "AE_stf_free_saurians_Sage",
            "AE_stf_eventide_Eventide_Herbalist",
            "AE_stf_eltireans_Elementalist",
            "AE_rhy_fd_Gnome_Forest",
            "AE_rhy_fd_Gnome_Rider",
            "AE_rhy_ce_Quack",
            "AE_rhy_tr_Researcher",
            "AE_rhy_tr_Energy",
            "AE_rhy_ma_Monk",
            "AE_rhy_ma_Adept",
            "AE_rhy_dw_Runeadept",
            "AE_rhy_aq_Mage",
            "AE_rhy_mh_Mage",
            "AE_rhy_de_Darkpriest",
            "AE_rhy_rg_Mage",
            "AE_rhy_lz_Priest",
            "AE_rhy_fh_Shaman",
            "AE_rhy_ey_Noble",
            "AE_fut_Nordhris_Apprentice",
            "AE_fut_Nordhris_Frenetic_Shaman",
            "AE_fut_welkin_Star_Shooter",
            "AE_fut_welkin_Neophyte",
            "AE_fut_welkin_Flurry",
            "AE_fut_welkin_Sage",
            "AE_fut_brungar_Ocean_Apprentice",
            "AE_fut_brungar_Apothecary",
            "AE_ele_Skeletal_Lich_Adept",
            "AE_ele_Skeletal_Corpse_Mage",
            "AE_feu_ceresians_Novice",
            "AE_feu_ceresians_Acolyte",
            "AE_feu_khaganate_Icewind_Herder",
            -- "AE_feu_clockwork_dwarves_Greaser",
            "AE_feu_high_elves_Faerie_Warrior",
            "AE_chs_elementals_Summoner_Initiate",
            "AE_chs_chaos_empire_Invoker",
            "AE_chs_wild_humans_Rogue_Mage",
            "AE_mrc_refugees_Cleaner",
            "AE_mrc_highlanders_Fieldmedic",
            "AE_mrc_fanatics_Genie",
            "AE_mrc_tribe_Shaman",
            "AE_mrc_enchanters_Rune_Apprentice",
            -- "AE_mrc_oracles_Cleric",
            "AE_mrc_oracles_Magnomancer",
            "AE_mrc_oracles_Darkmage",
            "AE_mrc_oracles_Wizard",
            "AE_mrc_oracles_Mage",
            "AE_mrc_oracles_Oracle",
            "AE_mrc_oracles_Summoner",
            "AE_mrc_oracles_Scientist",
            "AE_mrc_equestrians_Magerider",
            "AE_mrc_infernai_Ifreet",
            "AE_mrc_holy_order_Cleric",
            "AE_mrc_holy_order_Student",
            "AE_imp_Cavernei_Watcher",
            "AE_imp_Arendians_Druid",
            "AE_imp_Sidhe_Raindancer",
            "AE_imp_Sidhe_Hoarfroster",
            "AE_myh_Blood_Apprentice",
            "AE_myh_Wizard",
            "AE_myh_Therian_Apprentice",
            "AE_myh_Cursers",
            "AE_agl_desert_elves_dust_faerie",
        }
        trainee_female_advance = {
            "Mage", "Dark Adept", "Elvish Shaman", "Mermaid Initiate",
            -- "Dune Burner",
            "Elvish Shaman","Mermaid Initiate",
            "AE_mie_sylvan_keeper",
            "AE_mie_spirit_thorn_witch",
            "AE_mie_sylvan_underbrush_faerie",
            "AE_mie_sylvan_sprite",
            "AE_mie_cornur_shaman",
            "AE_mie_centaur_mystic",
            "AE_mie_thelian_shaman",
            "AE_efm_whites_Storm_Child",
            "AE_efm_darklanders_Malice_of_the_Gods",
            "AE_efm_pygmies_Swamp_Witch",
            "AE_mag_Nightmare",
            "AE_mag_Jinn",
            "AE_mag_Troll_Sorcerer",
            "AE_mag_Sister_of_Light",
            "AE_mag_Adept_of_Light",
            "AE_mag_Shamanistic_Adept",
            "AE_mag_Witch",
            "AE_arc_south_seas_Lore_Caster",
            "AE_arc_menagerie_Tower_Dancer",
            "AE_arc_ukians_Ukian_Archer",
            -- "AE_arc_primeval_Cutter",
            "AE_arc_despair_Widow",
            "AE_ext_dark_elves_Enchantress",
            "AE_ext_outlaws_Cunning_Woman",
            "AE_ext_chaos_Invoker",
            -- "AE_stf_eventide_Diu_Bowmaiden",
            "AE_stf_eltireans_Disciple_of_Eltire",
            "AE_rhy_vx_Shaman",
            "AE_rhy_tr_Researcher",
            "AE_rhy_tr_Energy",
            "AE_rhy_ma_Adept",
            "AE_rhy_aq_Mage",
            "AE_rhy_rg_Mage",
            "AE_rhy_ey_Shaman",
            "AE_rhy_ey_Waterpixie",
            "AE_rhy_ey_Noble",
            "AE_fut_welkin_Star_Shooter",
            "AE_fut_welkin_Neophyte",
            "AE_fut_welkin_Flurry",
            "AE_fut_welkin_Sage",
            "AE_ele_Skeletal_Witch",
            "AE_ele_Skeletal_Corpse_Mage",
            "AE_ele_Centaur_Seductress",
            "AE_ele_Centaur_Angelican",
            "AE_feu_khaganate_Icewind_Herder",
            "AE_feu_high_elves_Sorceress",
            "AE_feu_high_elves_Faerie_Warrior",
            "AE_chs_aragwaith_Witch",
            "AE_chs_quenoth_Quenoth_Mystic",
            "AE_chs_elementals_Summoner_Initiate",
            "AE_chs_sylvians_Sprite",
            "AE_chs_sylvians_Dusk_Faerie",
            "AE_chs_sylvians_Elvish_Acolyte",
            "AE_mrc_mercenaries_Neglect_Mage",
            "AE_mrc_avians_Mother",
            "AE_mrc_slavers_Harlot",
            "AE_mrc_slavers_Dancer",
            "AE_mrc_oracles_Cleric",
            "AE_imp_Marauders_Fay",
            "AE_imp_Issaelfr_Mistral_Magus",
            "AE_imp_Sidhe_Raindancer",
            "AE_imp_Sidhe_Hoarfroster",
            "AE_myh_Blood_Apprentice",
            "AE_myh_Water_Dryad",
            "AE_myh_Weaver",
            "AE_myh_Seeker",
            "AE_myh_Scribe",
            "AE_agl_yokai_Feyborn",
            "AE_agl_yokai_Poltergeist",
            "AE_agl_deep_Lidh",
            "AE_agl_deep_Priestress_of_the_Vault",
            "AE_agl_frozen_frost_student",
            "AE_agl_desert_elves_dust_faerie",
            "AE_agl_desert_elves_Shaman",
        }
    end
end

if not recall_list_done or gimme_more then
    for side_index, side in ipairs(sides) do
        if side.controller == 'human' then
            for i=1, num_zeroes, 1 do
                local u = wesnoth.create_unit {type=helper.rand(zero_units), random_gender="yes"}
                if change_recall_cost then
                    u.recall_cost = cost
                end
                -- Should this be done for all created units?
                if extra_units and (u.type == "LZH_Trainee_Mage") then
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
