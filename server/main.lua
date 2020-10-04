ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    TriggerClientEvent('esx_status_hud:load', playerId, data)
end)