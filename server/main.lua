ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    TriggerClientEvent('esx_status_hud:load', playerId, data)
end)

ESX.RegisterCommand('god', 'admin', function(xPlayer)
    xPlayer.triggerEvent('rza:god')
end, false, {help = 'Seta fome/sede/colete/vida no máximo'})


ESX.RegisterCommand('hh', 'admin', function(xPlayer)
    TriggerEvent('esx_status:set', 'hunger', 100200)
    TriggerEvent('esx_status:set', 'thirst', 100200)
end, false, {help = 'Seta fome/sede/colete/vida no máximo'})

-- restore hunger & thirst

