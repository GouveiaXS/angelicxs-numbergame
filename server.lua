ESX = nil
QBcore = nil

if Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('angelicxs-quickgamble:playgame')
AddEventHandler('angelicxs-quickgamble:playgame', function(game, info)
    local bet = tonumber(info.amount)
    local src = source
    local Player = nil
    local canPlay = false
    if Config.UseESX then
        Player = ESX.GetPlayerFromId(src)
        id = Player.identifier
        if Player.getMoney() >= bet then
            Player.removeMoney(bet)
            canPlay = true
        end
    elseif Config.UseQBCore then
        Player = QBCore.Functions.GetPlayer(src)
        id = Player.PlayerData.citizenid
        if Player.PlayerData.money['cash'] >= bet then
            Player.Functions.RemoveMoney('cash', bet, "Quick-Gamble")
            canPlay = true
        end
    end
    if canPlay then
        local SelectedNumber = RandomNumGen(tonumber(game.max))
        TriggerClientEvent('angelicxs-quickgamble:ShowNumber', src, tostring(SelectedNumber))
        TriggerClientEvent('angelicxs-quickgamble:Notify', src, Config.Lang['selected_number']..' '..tostring(SelectedNumber), Config.LangType['info'])
        if tonumber(info.number) == SelectedNumber then
            local amount = bet * tonumber(game.odds)
            if Config.UseESX then
                Player.addAccountMoney("money", amount)
            elseif Config.UseQBCore then
                Player.Functions.AddMoney("cash", amount, "Quick-Gamble-WIN")
            end
            TriggerClientEvent('angelicxs-quickgamble:Notify', src, Config.Lang['right_number']..tostring(amount), Config.LangType['success'])
        else
            TriggerClientEvent('angelicxs-quickgamble:Notify', src, Config.Lang['wrong_number'], Config.LangType['info'])
        end
    else
        TriggerClientEvent('angelicxs-quickgamble:Notify', src, Config.Lang['low_money'], Config.LangType['error'])
    end
end)

function RandomNumGen(max)
    local number = 0
    for i=1, 25 do
        number = math.random(0,max)
    end
    return number
end
