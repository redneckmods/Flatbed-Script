local lastTruck = 0
local lastVeh = 0

local lastTruckCoords = vector3(0,0,0)
local r,g,b = 255,0,0
local start = 0.1
local extended = false
local attached = false
local trucks = {}

local vehicle = nil
local rope_saver = {}
local carryingRope = nil
local attachedVehicle = nil
local ropeCoords = nil



local vehs = {}
for k,v in ipairs(config.flatbed_name) do
    table.insert(vehs, GetHashKey(v))
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, true)
        local pos = GetEntityCoords(ped)

        if veh and has_value(vehs, GetEntityModel(veh)) then
            lastTruck = veh
            lastTruckCoords = GetEntityCoords(lastTruck)
        else
            lastVeh = veh
        end

        if IsPedInAnyVehicle(ped, true) == false and lastTruck ~= 0 then
            markerCoords = GetOffsetFromEntityInWorldCoords(lastTruck, -1.2, -4.75, 0.0)
            if IsControlJustReleased(0, 109) then 
                if carryingRope then
                    startRope2()
                end
            end
            if GetDistanceBetweenCoords(pos,markerCoords) < 5 then
                if config.FloatingText == true then
                    if not extended == true then
                        DrawText3D(markerCoords.x, markerCoords.y, markerCoords.z, config.controlText)
                    else
                        if not carryingRope then
                            DrawText3D(markerCoords.x, markerCoords.y, markerCoords.z, config.controlText2)
                        else
                            DrawText3D(markerCoords.x, markerCoords.y, markerCoords.z, config.controlText3)
                        end
                    end
                else
                    if not extended == true then
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
                        Citizen.InvokeNative(0x5F68520888E69014, config.labelText)
                        Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)
                    else
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
                        if not carryingRope then
                            Citizen.InvokeNative(0x5F68520888E69014, config.labelText2)
                        else
                            Citizen.InvokeNative(0x5F68520888E69014, config.labelText3)
                        end
                        Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)


                    end
                end

                if GetDistanceBetweenCoords(markerCoords,pos) < 2 then
                    if IsControlJustPressed(0,111) or IsControlJustPressed(0,112) then
                        if trucks[lastTruck] ~= nil and trucks[lastTruck]['bedslide2'] ~= nil then
                            start = trucks[lastTruck]['bedslide2']
                        end
                    end
                    if IsControlPressed(0, 111) then 
                        bedslide2('extend')
                    end
                    if IsControlJustReleased(0, 108) then 
                        startRope()
                    end

                    if IsControlJustReleased(0,111) or IsControlJustReleased(0,112) then
                        TriggerServerEvent('saveArmPosition',lastTruck,start)
                    end
                    if IsControlPressed(0, 112) and start ~= 0.0 then
                        bedslide2('retract')
                    end
                end
            end         
        elseif has_value(vehs, GetEntityModel(veh)) and lastTruck ~= 0 then
            if IsControlJustPressed(0,111) or IsControlJustPressed(0,112) or IsControlJustPressed(0,21) or IsControlJustPressed(0,36) then
                if trucks[lastTruck] ~= nil and trucks[lastTruck]['bedslide'] ~= nil then
                    start = trucks[lastTruck]['bedslide']
                end
            end
            if IsControlPressed(0, 111) or IsControlPressed(0,21) then 
                bedslide('extend')
            end
            if IsControlJustReleased(0,111) or IsControlJustReleased(0,112) then
                TriggerServerEvent('saveArmPosition',lastTruck,start)
            end
            if (IsControlPressed(0, 112) or IsControlPressed(0, 36))  and start ~= 0.0 then
                bedslide('retract')
            end
        end
        Wait(0)
    end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        local pos = GetEntityCoords(lastVeh)
        local entityWorld = GetOffsetFromEntityInWorldCoords(lastVeh, 0.0, 6.0, -5.0)
        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, lastVeh, -1)
        local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

        if extended == true then
            FreezeEntityPosition(lastTruck, true)
        else
            FreezeEntityPosition(lastTruck, false)
        end

        if IsPedInAnyVehicle(ped, false) then
            if IsEntityAttached(veh) then
                if IsControlJustReleased(0, config.carAttach) then
                    if trucks[lastTruck] ~= nil and trucks[lastTruck]['attached'] ~= nil then
                        attached = trucks[lastTruck]['attached']
                    end
                    if attached == true then
                        DetachEntity(veh,true,true)
                        attached = false
                        TriggerServerEvent('saveAttachment',lastTruck,attached)
                    end
                end
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringKeyboardDisplay(config.carDetachLabel)
                EndTextCommandDisplayHelp(0, false, true, -1)
            else
                if vehicleHandle ~= nil and has_value(vehs, GetEntityModel(vehicleHandle)) then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringKeyboardDisplay(config.carAttachLabel)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                end
                if IsControlJustReleased(0, config.carAttach) then
                    if vehicleHandle ~= nil and has_value(vehs, GetEntityModel(vehicleHandle)) then
                        local boneIndex = GetEntityBoneIndexByName(vehicleHandle, "misc_z")
                        local towOffset = GetOffsetFromEntityInWorldCoords(vehicleHandle, 0.0, -2.2, 0.4)
                        local towRot = GetEntityRotation(vehicleHandle, 1)
                        local vehicleHeightMin, vehicleHeightMax = GetModelDimensions(GetEntityModel(lastVeh))
                        AttachEntityToEntity(lastVeh, vehicleHandle, boneIndex, 0, 0.0, 0.08 - vehicleHeightMin.z, 2.0, 0, 0, 1, 1, 1, 1, 0, 1)

                        attached = true
                        TriggerServerEvent('saveAttachment', vehicleHandle, attached)
                    end
                end
            end
        end
    end
end)

function bedslide(doThing)
    if doThing == 'extend' then
        if start <= 0.3 then
            start = start +0.005
            extended = false
            PlaySoundFromEntity(-1,'Hydraulics_Down',lastTruck,'Lowrider_Super_Mod_Garage_Sounds',0,0)
            SetVehicleBulldozerArmPosition(lastTruck,start,false)
        else
            start = 0.3
            extended = true
        end
    end
    if doThing == 'retract' then
        extended = false
        if start > 0.10 then
            start = start -0.005
            PlaySoundFromEntity(-1,'Hydraulics_Up',lastTruck,'Lowrider_Super_Mod_Garage_Sounds',0,0)
            SetVehicleBulldozerArmPosition(lastTruck,start,false)
        else
            start = 0.10
            SetVehicleBulldozerArmPosition(lastTruck,0.020,false)
        end    
    end
    Citizen.Wait(config.SlidingSpeed)
end

function bedslide2(doThing)
    if doThing == 'extend' then
        if start <= 0.3 then
            start = start +0.005
            extended = false
            PlaySoundFromEntity(-1,'Hydraulics_Down',lastTruck,'Lowrider_Super_Mod_Garage_Sounds',0,0)
            SetVehicleBulldozerArmPosition(lastTruck,start,false)
        else
            start = 0.3
            extended = true
        end
    end
    if doThing == 'retract' then
        extended = false
        if start > 0.10 then
            start = start -0.005
            PlaySoundFromEntity(-1,'Hydraulics_Up',lastTruck,'Lowrider_Super_Mod_Garage_Sounds',0,0)
            SetVehicleBulldozerArmPosition(lastTruck,start,false)
        else
            start = 0.10
            SetVehicleBulldozerArmPosition(lastTruck,0.00,false)
        end    
    end
    Citizen.Wait(config.SlidingSpeed)
end

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
          SetTextScale(0.35, 0.35)
          SetTextFont(4)
          SetTextProportional(1)
          SetTextColour(255, 255, 255, 215)
          SetTextEntry("STRING")
          SetTextCentre(1)
          AddTextComponentString(text)
          DrawText(_x,_y)
          local factor = (string.len(text)) / 370
          DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 18, 18, 18, 170)
      end
end

RegisterNetEvent('saveTrucks')
AddEventHandler('saveTrucks', function(data)
    trucks = data
end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function startRope()
    local lastVehicle = lastTruck
    if lastVehicle ~= -1 then
        attachedVehicle = NetworkGetNetworkIdFromEntity(lastVehicle)
        if not carryingRope then
            attachedVehicle = NetworkGetNetworkIdFromEntity(lastVehicle)
            TriggerServerEvent('doTheRop',NetworkGetNetworkIdFromEntity(lastVehicle),NetworkGetNetworkIdFromEntity(PlayerPedId()))
            SetTextComponentFormat("STRING")
            AddTextComponentString(config.ropeText)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            carryingRope = true 
        else
            TriggerServerEvent('doTheRopR',attachedVehicle)
            carryingRope = nil
        end
    end
end
RegisterNetEvent('ropeToClientDataR')
AddEventHandler('ropeToClientDataR',function(entotyVeh)
    DeleteRope(rope_saver[entotyVeh])
end)


RegisterNetEvent('ropeToClientData')
AddEventHandler('ropeToClientData',function(player,entityVeh,playerCoords,vehCoords,ropeDefs)
    rope_saver[entityVeh]  = {}
    local playerPed = NetworkGetEntityFromNetworkId(player)
    local vehicle = NetworkGetEntityFromNetworkId(entityVeh)
    local pCoords = playerCoords
    local vCoords = vehCoords
    RopeLoadTextures()
    local rope = AddRope(pCoords, 0.0, 0.0, 0.0, 30.0, 2, 25.0, 1.0, 0, 0, 0, 0, 0, 0, 0)
    rope_saver[entityVeh] = rope
    local boneIndex = GetEntityBoneIndexByName(vehicle, "misc_z")
    ropeCoords = GetWorldPositionOfEntityBone(vehicle,boneIndex)
    AttachRopeToEntity(rope, vehicle, ropeCoords, 1)
    AttachEntitiesToRope(rope,vehicle,playerPed,ropeCoords,pCoords,100)
end)

function startRope2()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestVeh = GetClosestVehicle(playerCoords, 10.001, 0, 70)
    TriggerServerEvent('doTheRopFinal',NetworkGetNetworkIdFromEntity(closestVeh),attachedVehicle,ropeCoords)
end
RegisterNetEvent('ropeToClientDataFinal')
AddEventHandler('ropeToClientDataFinal',function(closestVeh,attachedVehicle,ropeCoords)
    local closestVeh = NetworkGetEntityFromNetworkId(closestVeh)
    local boneIndex = GetEntityBoneIndexByName(NetworkGetEntityFromNetworkId(attachedVehicle), "misc_z")

    if rope_saver[attachedVehicle] then
        AttachEntitiesToRope(rope_saver[attachedVehicle],NetworkGetEntityFromNetworkId(attachedVehicle),closestVeh,ropeCoords,GetWorldPositionOfEntityBone(closestVeh,GetEntityBoneIndexByName(closestVeh,"bonnet"),100))
        DetachRopeFromEntity(rope_saver[attachedVehicle],PlayerPedId())
        StartRopeWinding(rope_saver[attachedVehicle])
        FreezeEntityPosition(NetworkGetEntityFromNetworkId(attachedVehicle),true)
        while RopeGetDistanceBetweenEnds( rope_saver[attachedVehicle]) >= 1.05 do
            RopeForceLength(rope_saver[attachedVehicle],RopeGetDistanceBetweenEnds( rope_saver[attachedVehicle])-0.1)
            Citizen.Wait(50)
        end
        local vehicleHeightMin, vehicleHeightMax = GetModelDimensions(GetEntityModel(closestVeh))
        FreezeEntityPosition(NetworkGetEntityFromNetworkId(attachedVehicle),false)
        AttachEntityToEntity(closestVeh, NetworkGetEntityFromNetworkId(attachedVehicle), boneIndex, 0, 0.0, 0.08 - vehicleHeightMin.z, 2.0, 0, 0, 1, 1, 1, 1, 0, 1)
        DeleteRope( rope_saver[attachedVehicle])
        rope_saver[attachedVehicle] = nil
        carryingRope = nil
        attached = true
        TriggerServerEvent('saveAttachment', NetworkGetEntityFromNetworkId(attachedVehicle), attached)
    end
end)
