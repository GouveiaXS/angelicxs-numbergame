----------------------------------------------------------------------
-- Thanks for supporting AngelicXS Scripts!							--
-- Support can be found at: https://discord.gg/tQYmqm4xNb			--
-- More paid scripts at: https://angelicxs.tebex.io/ 				--
-- More FREE scripts at: https://github.com/GouveiaXS/ 				--
----------------------------------------------------------------------
-- Model info: https://docs.fivem.net/docs/game-references/ped-models/
-- Blip info: https://docs.fivem.net/docs/game-references/blips/


Config = {}

Config.UseESX = false						-- Use ESX Framework
Config.UseQBCore = true						-- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.NHInput = false						-- Use NH-Input [https://github.com/nerohiro/nh-keyboard]
Config.NHMenu = false						-- Use NH-Menu [https://github.com/nerohiro/nh-context]
Config.QBInput = true						-- Use QB-Input (Ignored if Config.NHInput = true) [https://github.com/qbcore-framework/qb-input]
Config.QBMenu = true						-- Use QB-Menu (Ignored if Config.NHMenu = true) [https://github.com/qbcore-framework/qb-menu]
Config.OXLib = false						-- Use the OX_lib (Ignored if Config.NHInput or Config.QBInput = true) [https://github.com/overextended/ox_lib]  !! must add shared_script '@ox_lib/init.lua' and lua54 'yes' to fxmanifest!!

Config.UseCustomNotify = false				-- Use a custom notification script, must complete event below.
-- Only complete this event if Config.UseCustomNotify is true; mythic_notification provided as an example
RegisterNetEvent('angelicxs-quickgamble:CustomNotify')
AddEventHandler('angelicxs-quickgamble:CustomNotify', function(message, type)
    --exports.mythic_notify:SendAlert(type, message, 4000)
end)

-- Visual Preference
Config.Use3DText = true 					-- Use 3D text for interactions; only turn to false if Config.UseThirdEye is turned on and IS working.
Config.UseThirdEye = true 					-- Enables using a third eye (third eye requires the following arguments debugPoly, useZ, options {event, icon, label}, distance)
Config.ThirdEyeName = 'qb-target' 			-- Name of third eye aplication

Config.Blips = false                        -- If true, turns on blips
Config.BlipSprite = 679                     -- If Config.Blips = true then, is the shape of the blip
Config.BlipSize = 0.7                       -- If Config.Blips = true then, is the size of the blip
Config.BlipColour = 48                      -- If Config.Blips = true then, is the colour of the blip
Config.BlipName = 'Number Gambler'          -- If Config.Blips = true then, is the name of the blip

Config.NPCModel = 's_m_m_fiboffice_01'      -- What model ped will be used
Config.GambleNPCLocations = {               -- Locations of gambling ped
    vector4(217.33, -865.36, 30.49, 254.0),
    vector4(-1615.84, -1055.28, 13.09, 147.1),
}

-- Language Configuration
Config.LangType = {
	['error'] = 'error',
	['success'] = 'success',
	['info'] = 'primary'
}

Config.Lang = {
	['ask_gamble'] = "Play the number quick gamble!",
	['ask_gamble_3d'] = "Press ~r~E~w~ to play the number quick gamble!",
	['quick_gamble_header'] = "Choose your number game!",
	['0-10'] = "Choose a number between 0-10, correct choice pays 10x!",
	['0-100'] = "Choose a number between 0-100, correct choice pays 100x!",
	['0-1000'] = "Choose a number between 0-1000, correct choice pays 1000x!",
	['gamble_input'] = "Enter your gambling information",
	['gamble_number'] = "Select your number!",
	['gamble_amount'] = "Place your bet!",
	['input_error'] = "You have inputed something wrong.",
	['selected_number'] = "The selected number is:",
	['right_number'] = "CONGRATULATIONS YOU WIN $",
	['wrong_number'] = "So close! You selected the wrong number!",
	['low_money'] = "You do not have enough money to make this bet",
}