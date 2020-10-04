Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function getThirst()
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.getPercent()
    end)

    return thirst
end

function getHunger()
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        hunger = status.getPercent()
    end)

    return hunger
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.UpdateHudInterval)

        local thirst = getThirst()
        local hunger = getHunger()

        SendNUIMessage({
            thirst = thirst,
            hunger = hunger
        })        
    end 
end)

RegisterNetEvent('esx_status_hud:load')
AddEventHandler('esx_status_hud:load', function (name, args)
    local ped = PlayerPedId()
    local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
    local pedArmor = GetPedArmour(GetPlayerPed(-1))

    if pedLife > 1 then
        SendNUIMessage({
            bulletproof = pedArmor,
            life = pedLife
        })
    end
end)

AddEventHandler('gameEventTriggered', function (name, args)
    local ped = PlayerPedId()
    
    -- args[1] = Ped que recebeu o dano
    if name ==  'CEventNetworkEntityDamage' and args[1] == ped then
		local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
		local pedArmor = GetPedArmour(GetPlayerPed(-1))

		if pedLife > 1 then
            SendNUIMessage({
				bulletproof = pedArmor,
                life = math.ceil(pedLife)
			})
		end 
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    SendNUIMessage({
        playerDead = true
    })
end)

AddEventHandler('playerSpawned', function(spawn)
    local ped = PlayerPedId()
    local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
    local pedArmor = GetPedArmour(GetPlayerPed(-1))

    if pedLife > 1 then
        SendNUIMessage({
            bulletproof = pedArmor,
            life = pedLife,
            playerDead = false
        })
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
   
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end

    local ped = PlayerPedId()
    local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
    local pedArmor = GetPedArmour(GetPlayerPed(-1))
    
    if pedLife > 1 then
        SendNUIMessage({
            bulletproof = pedArmor,
            life = pedLife,
            res = resourceName,
            playerDead = false
        })
    end
  end)
  