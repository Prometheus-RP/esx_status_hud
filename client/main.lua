local thirst = nil
local hunger = nil

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

AddEventHandler('esx_status:loaded', function(status)
    
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while true do
            Citizen.Wait(1000)
            
            local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
		    local pedArmor = GetPedArmour(GetPlayerPed(-1))
            
            thirst = getThirst()
            hunger = getHunger()
            
            SendNUIMessage({
                life = pedLife,
                thirst = thirst,
                hunger = hunger,
                playerDead = pedLife < 1,
                showPersonHud = true,
            })
        end
    end)
end)

AddEventHandler('gameEventTriggered', function (name, args)
    local ped = PlayerPedId()

    -- args[1] = Ped que recebeu o dano
    if name == 'CEventNetworkEntityDamage' and args[1] == ped then
		local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
		local pedArmor = GetPedArmour(GetPlayerPed(-1))

		if pedLife > 1 then
            SendNUIMessage({
                playerDead = false,
                showPersonHud = true,
				bulletproof = pedArmor,
                life = math.ceil(pedLife)
			})
		end 
	end
end)

AddEventHandler('playerSpawned', function(spawn)
    local ped = PlayerPedId()
    local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)
    local pedArmor = GetPedArmour(GetPlayerPed(-1))

    
    thirst = getThirst()
    hunger = getHunger()

    if pedLife > 1 then
        SendNUIMessage({
            bulletproof = pedArmor,
            life = pedLife,
            thirst = thirst,
            hunger = hunger,
            playerDead = false,
            showPersonHud = true,
        })
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
   
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
end)


RegisterNUICallback('esx_status_hud:loadInterface', function(data, cb)

	if data.loaded == true then
        local ped = PlayerPedId()
        local pedLife = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)

        thirst = getThirst()
        hunger = getHunger()

        if pedLife > 1 then
            cb({
                labels = {
                    life = _U('life'),
                    armor = _U('armor'),
                    hunger = _U('hunger'),
                    thirst = _U('thirst')
                },
                hudSize = Config.HudSize,
                barWeight = Config.BarWeight,
                bulletproof = pedArmor,
                life = pedLife,
                thirst = thirst,
                hunger = hunger,
                playerDead = false,
                showPersonHud = true,
            })
        else
            cb({
                playerDead = true,
            })
        end
    end
end)


AddEventHandler('esx:onPlayerDeath', function(data)
    SendNUIMessage({
        playerDead = true
    })
end)
