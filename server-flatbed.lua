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