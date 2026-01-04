-- Helper function to load model with timeout
local function LoadModel(model, timeout)
    timeout = timeout or 5000
    local hash = type(model) == 'string' and GetHashKey(model) or model
    
    if not IsModelValid(hash) then
        print('[rpa-garages] Invalid model: ' .. tostring(model))
        return false
    end
    
    RequestModel(hash)
    local startTime = GetGameTimer()
    while not HasModelLoaded(hash) do
        if GetGameTimer() - startTime > timeout then
            print('[rpa-garages] Model load timeout: ' .. tostring(model))
            return false
        end
        Wait(10)
    end
    return true
end

-- Trigger callback using framework bridge
local function TriggerCallback(name, cb, ...)
    local fwName = exports['rpa-lib']:GetFrameworkName()
    
    if fwName == 'qb-core' or fwName == 'qbox' then
        exports['rpa-lib']:GetFramework().Functions.TriggerCallback(name, cb, ...)
    elseif fwName == 'ox_core' then
        if GetResourceState('ox_lib') == 'started' then
            local result = lib.callback.await(name, false, ...)
            cb(result)
        end
    end
end

local function SpawnVehicle(model, plate, spawnPoint)
    if not LoadModel(model) then
        exports['rpa-lib']:Notify("Failed to load vehicle model", "error")
        return
    end

    local veh = CreateVehicle(model, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w, true, false)
    SetVehicleNumberPlateText(veh, plate)
    SetEntityAsMissionEntity(veh, true, true)
    
    -- Keys logic 
    exports['rpa-vehiclekeys']:GiveKeys(plate)
    exports['rpa-lib']:Notify("Vehicle Retrieved", "success")
    
    -- Full tank on retrieve (check if export exists)
    if GetResourceState('rpa-fuel') == 'started' then
        exports['rpa-fuel']:SetFuel(veh, 100)
    end
end

local function OpenGarageMenu(garageId)
    local garage = Config.Garages[garageId]
    
    -- Request vehicle list using callback bridge
    TriggerCallback('rpa-garages:server:GetVehicles', function(vehicles)
        local options = {}
        
        for _, v in pairs(vehicles) do
            local state = "In Garage"
            if v.state == 0 then state = "Out" end
            
            table.insert(options, {
                title = v.vehicle, -- Should be label
                description = "Plate: " .. v.plate .. " | State: " .. state,
                event = "rpa-garages:client:spawnVehicle",
                args = {
                    vehicle = v,
                    spawnPoint = garage.spawnPoint
                }
            })
        end

        -- Using ox_lib context if available or generic menu mock
        if exports['rpa-lib']:GetFrameworkName() == 'ox_core' or exports['rpa-lib']:GetFrameworkName() == 'qbox' or GetResourceState('ox_lib') == 'started' then
             lib.registerContext({
                id = 'garage_menu',
                title = garage.label,
                options = options
            })
            lib.showContext('garage_menu')
        else
            -- Simple fallback print for now if no menu lib
            print("Vehicles:", json.encode(vehicles))
            exports['rpa-lib']:Notify("Check console for vehicle list (Menu lib missing)", "info")
            
            -- Basic auto spawn first one for testing if list not empty
            if #vehicles > 0 then
                 SpawnVehicle(vehicles[1].vehicle, vehicles[1].plate, garage.spawnPoint)
            end
        end
    end)
end

RegisterNetEvent('rpa-garages:client:spawnVehicle', function(data)
    SpawnVehicle(data.vehicle.vehicle, data.vehicle.plate, data.spawnPoint)
    TriggerServerEvent('rpa-garages:server:UpdateState', data.vehicle.plate, 0) -- Out
end)

-- Store Vehicle Logic
local function StoreVehicle(garageId)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        TriggerServerEvent('rpa-garages:server:UpdateState', plate, 1) -- In
        DeleteEntity(veh)
        exports['rpa-lib']:Notify("Vehicle Stored", "success")
    else
        exports['rpa-lib']:Notify("No vehicle found", "error")
    end
end

CreateThread(function()
    for k, v in pairs(Config.Garages) do
        -- Spawn Ped with timeout protection
        if not LoadModel(v.ped.model) then
            print('[rpa-garages] Failed to load ped model for garage: ' .. k)
            goto continue
        end
        
        local hash = GetHashKey(v.ped.model)
        local ped = CreatePed(4, hash, v.ped.coords.x, v.ped.coords.y, v.ped.coords.z, v.ped.coords.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        -- Target
        exports['rpa-lib']:AddTargetModel(v.ped.model, {
            options = {
                {
                    label = "Open Garage",
                    icon = "fas fa-warehouse",
                    action = function() OpenGarageMenu(k) end
                },
                {
                    label = "Store Vehicle",
                    icon = "fas fa-parking",
                    action = function() StoreVehicle(k) end
                }
            }
        })
        
        -- Blip
        local blip = AddBlipForCoord(v.ped.coords.x, v.ped.coords.y, v.ped.coords.z)
        SetBlipSprite(blip, 357)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garage")
        EndTextCommandSetBlipName(blip)
        
        ::continue::
    end
end)
