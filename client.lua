

ESX = nil
QBcore = nil

local PedSpawned = false
local NPC = nil


CreateThread(function()
    if Config.UseESX then
        ESX = exports["es_extended"]:getSharedObject()
    elseif Config.UseQBCore then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    if Config.Blips then
        for i=1, #Config.GambleNPCLocations, 1 do
			local spot = Config.GambleNPCLocations[i]
            local v3 = vector3(spot.x, spot.y, spot.z)
            Blip(v3)
        end
    end
end)

RegisterNetEvent('angelicxs-quickgamble:Notify', function(message, type)
	if Config.UseCustomNotify then
        TriggerEvent('angelicxs-quickgamble:CustomNotify',message, type)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

-- NPC Spawn
CreateThread(function()
    while true do
        local Player = PlayerPedId()
		local Pos = GetEntityCoords(Player) 
		local Dist = nil
		for i=1, #Config.GambleNPCLocations, 1 do
			local spot = Config.GambleNPCLocations[i]
			Dist = #(Pos - vector3(spot.x,spot.y,spot.z))
			if Dist <= 50 and not PedSpawned then
                TriggerEvent('angelicxs-quickgamble:SpawnNPC',spot,Config.NPCModel)
                PedSpawned = true
            elseif DoesEntityExist(NPC) and PedSpawned then
                local Dist2 = #(Pos - GetEntityCoords(NPC))
                if Dist2 > 50 then
                    DeleteEntity(NPC)
                    PedSpawned = false
                end
            end

		end
        Wait(2000)
    end
end)

RegisterNetEvent('angelicxs-quickgamble:SpawnNPC',function(coords,model)
	local hash = GetHashKey(model)
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do
		Wait(10)
	end
    NPC = CreatePed(3, hash, coords.x, coords.y, (coords.z-1), coords.w, false, false)
    FreezeEntityPosition(NPC, true)
    SetEntityInvincible(NPC, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    TaskStartScenarioInPlace(NPC,'WORLD_HUMAN_STAND_IMPATIENT', 0, false)
    SetModelAsNoLongerNeeded(model)
    if Config.UseThirdEye then
		if Config.ThirdEyeName == 'ox_target' then
			local ox_options = {
				{
					name = 'quickgamble',
					event = 'angelicxs-quickgamble:chooselevel',
					label = Config.Lang['ask_gamble'],
				},
			}
			exports.ox_target:addLocalEntity(NPC, ox_options)
		else
			exports[Config.ThirdEyeName]:AddEntityZone('GambleNPC', NPC, {
				name="GambleNPC",
				debugPoly=false,
				useZ = true
				}, {
				options = {
					{
						event = 'angelicxs-quickgamble:chooselevel', 
						label = Config.Lang['ask_gamble'],
					},    	
				},
				distance = 2
			})       
		end 
	end
end)

CreateThread(function()
	while Config.Use3DText do
		local sleep = 2000
		local Player = PlayerPedId()
		local Pos = GetEntityCoords(Player) 
		local Dist = nil
		for i=1, #Config.GambleNPCLocations, 1 do
			local spot = Config.GambleNPCLocations[i]
			Dist = #(Pos - vector3(spot.x,spot.y,spot.z))
			if Dist <= 50 then
				sleep = 1000
				if Dist <= 25 then
					sleep = 500
					if Dist <= 10 then
						DrawText3Ds(spot.x,spot.y,spot.z, Config.Lang['ask_gamble_3d'])
						if IsControlJustReleased(0, 38) then
							TriggerEvent('angelicxs-quickgamble:chooselevel')
						end
						sleep = 0
					end
				end
            end
		end
		Wait(sleep)
	end
end)

RegisterNetEvent('angelicxs-quickgamble:chooselevel', function()
	local menu = {}
	if Config.NHMenu then
		table.insert(menu, {
			header = Config.Lang['quick_gamble_header'],
		})
		table.insert(menu, {
			context = Config.Lang['0-10'],
			event = 'angelicxs-quickgamble:inputnumbers',
			args = { 1 }
		})
		table.insert(menu, {
			context = Config.Lang['0-100'],
			event = 'angelicxs-quickgamble:inputnumbers',
			args = { 2 }
		})
		table.insert(menu, {
			context = Config.Lang['0-1000'],
			event = 'angelicxs-quickgamble:inputnumbers',
			args = { 3 }
		})
	elseif Config.QBMenu then
		table.insert(menu, {
			header = Config.Lang['quick_gamble_header'],
			isMenuHeader = true
		})
		table.insert(menu, {
			header = Config.Lang['0-10'],
			params = {
				event = 'angelicxs-quickgamble:inputnumbers',
				args = 1
			}
		})
		table.insert(menu, {
			header = Config.Lang['0-100'],
			params = {
				event = 'angelicxs-quickgamble:inputnumbers',
				args = 2
			}
		})
		table.insert(menu, {
			header = Config.Lang['0-1000'],
			params = {
				event = 'angelicxs-quickgamble:inputnumbers',
				args = 3
			}
		})
	elseif Config.OXLib then
		table.insert(menu, {
			label = Config.Lang['0-10'],
			args = { data = 1}
		})
		table.insert(menu, {
			label = Config.Lang['0-100'],
			args = { data = 2 }
		})
		table.insert(menu, {
			label = Config.Lang['0-1000'],
			args = { data = 3 }
		})
	end
	if Config.NHMenu then
		TriggerEvent("nh-context:createMenu", menu)
	elseif Config.QBMenu then
		TriggerEvent("qb-menu:client:openMenu", menu)
	elseif Config.OXLib then
		lib.registerMenu({
			id = 'gamblemenu_ox',
			title = Config.Lang['quick_gamble_header'],
			options = menu,
			position = 'top-right',
		}, function(selected, scrollIndex, args)
				TriggerEvent("angelicxs-quickgamble:inputnumbers", args.data)
		end)
		lib.showMenu('gamblemenu_ox')
	end 
end)

RegisterNetEvent('angelicxs-quickgamble:inputnumbers', function(data)
	local restrictions = {}
	if data == 1 then
		restrictions.max = 10
		restrictions.odds = 10
	elseif data == 2 then
		restrictions.max = 100
		restrictions.odds = 100
	elseif data == 3 then
		restrictions.max = 1000
		restrictions.odds = 1000
	end
	local gambleInfo = {}
	if Config.NHInput then
		local keyboard, amount = exports["nh-keyboard"]:Keyboard({
			header = Config.Lang['gamble_input'],
			rows = {Config.Lang['gamble_number'], Config.Lang['gamble_amount']} 
		})
		if keyboard then
			if tonumber(amount[1]) >= 0 and tonumber(amount[1]) <= restrictions.max and tonumber(amount[2]) >= 0 then
				gambleInfo.number = tonumber(amount[1])
				gambleInfo.amount = tonumber(amount[2])
			else
				TriggerEvent('angelicxs-quickgamble:Notify', Config.Lang['input_error'], Config.LangType['error'])
			end
		end
	elseif Config.QBInput then
		local info = exports['qb-input']:ShowInput({
			header = Config.Lang['gamble_input'],
			submitText = Config.Lang['gamble_submit'], 
			inputs = {
				{
					type = 'number',
					isRequired = true,
					name = 'number',
					text = Config.Lang['gamble_number'],
				},
				{
					type = 'number',
					isRequired = true,
					name = 'amount',
					text = Config.Lang['gamble_amount'], 
				},
			}
		})    
		if info then
			if tonumber(info.number) >= 0 and tonumber(info.number) <= restrictions.max and tonumber(info.amount) >= 0 then
				gambleInfo.number = tonumber(info.number)
				gambleInfo.amount = tonumber(info.amount)
			else
				TriggerEvent('angelicxs-quickgamble:Notify', Config.Lang['input_error'], Config.LangType['error'])
			end
		end
	elseif Config.OXLib then
		local input = lib.inputDialog(Config.Lang['gamble_input'], {Config.Lang['gamble_number'], Config.Lang['gamble_amount']})
		if not input then return end
		if tonumber(input[1]) >= 0 and tonumber(input[1]) <= restrictions.max and tonumber(input[2]) >= 0 then
			gambleInfo.number = tonumber(input[1])
			gambleInfo.amount = tonumber(input[2])
		else
			TriggerEvent('angelicxs-quickgamble:Notify', Config.Lang['input_error'], Config.LangType['error'])
		end
	end
	TriggerServerEvent('angelicxs-quickgamble:playgame', restrictions, gambleInfo)
end)

RegisterNetEvent('angelicxs-quickgamble:ShowNumber', function(number)
	local spot = GetEntityCoords(NPC)
	if spot then
		for i=1, 150 do
			DrawText3Ds(spot.x,spot.y,spot.z+1,number)
			Wait(0)
		end
	end
end)

function Blip(coords)
    local Blip = AddBlipForCoord(coords)
    SetBlipSprite(Blip, Config.BlipSprite)
    SetBlipScale(Blip, Config.BlipSize)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, Config.BlipColour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Number Gambler')
    EndTextCommandSetBlipName(Blip)
end

-- 3D Text Functionality
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if DoesEntityExist(NPC) then
            DeleteEntity(NPC)
        end
    end
end)
