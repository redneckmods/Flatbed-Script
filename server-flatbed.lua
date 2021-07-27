trucks = {}

RegisterServerEvent('saveAttachment')
AddEventHandler('saveAttachment',function(truck,status)
    if DoesEntityExist(truck) then
        if trucks[truck] == nil then    
            createTruck(truck)
        end
        trucks[truck]['attached'] = status
        TriggerClientEvent('saveTrucks',-1,trucks[truck])
    else
        if trucks[truck] ~= nil then    
            delete(truck)
        end
    end
end)

RegisterServerEvent('saveArmPosition')
AddEventHandler('saveArmPosition',function(truck,position)
    if DoesEntityExist(truck) then
        if trucks[truck] == nil then    
            createTruck(truck)
        end
        trucks[truck]['arm'] = position
        TriggerClientEvent('saveTrucks',-1,trucks[truck])
    else
        if trucks[truck] ~= nil then    
            delete(truck)
        end
    end
end)

ropeDefs = {}
RegisterServerEvent('doTheRop')
AddEventHandler('doTheRop',function(vehNetId,playerId)
    local src = source
    print(playerId)
    local player = NetworkGetEntityFromNetworkId(playerId)
    local entityVeh = NetworkGetEntityFromNetworkId(vehNetId)
    local playerCoords = GetEntityCoords(player)
    local vehCoords = GetEntityCoords(entityVeh)
    table.insert(ropeDefs,{vehicleTow = entityVeh,vehCoords = vehCoords,playerCoords = playerCoords,caller = playerId})
    TriggerClientEvent('ropeToClientData',-1,playerId,vehNetId,playerCoords,vehCoords,ropeDefs)
end)
RegisterServerEvent('doTheRopFinal')
AddEventHandler('doTheRopFinal',function(closestVehId,attachedVehicleId,ropeCoords)
    TriggerClientEvent('ropeToClientDataFinal',-1,closestVehId,attachedVehicleId,ropeCoords)
end)


RegisterServerEvent('doTheRopR')
AddEventHandler('doTheRopR',function(closestVehId)
    TriggerClientEvent('ropeToClientDataR',-1,closestVehId)
end)


function createTruck(truck)
    table.insert(trucks[truck],
    {
        arm = 0.0,
        attached = false
    })
    TriggerClientEvent('addTruck',-1,trucks[truck])
end
function delete(truck)
    trucks[truck] = nil
end