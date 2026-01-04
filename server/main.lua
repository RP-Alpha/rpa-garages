-- Server-side garage management using rpa-lib bridge

local function GetPlayer(src)
    local Framework = exports['rpa-lib']:GetFramework()
    if Framework then
        return Framework.Functions.GetPlayer(src)
    end
    return nil
end

-- Callback registration using framework bridge
local function RegisterCallback(name, cb)
    local Framework = exports['rpa-lib']:GetFramework()
    local fwName = exports['rpa-lib']:GetFrameworkName()
    
    if fwName == 'qb-core' or fwName == 'qbox' then
        Framework.Functions.CreateCallback(name, cb)
    elseif fwName == 'ox_core' then
        -- ox_core uses lib.callback
        if GetResourceState('ox_lib') == 'started' then
            lib.callback.register(name, cb)
        end
    end
end

-- Register the GetVehicles callback
RegisterCallback('rpa-garages:server:GetVehicles', function(source, cb)
    local src = source
    local Player = GetPlayer(src)
    
    if Player then
        local citizenid = Player.PlayerData.citizenid
        MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ?', { citizenid }, function(result)
            cb(result or {})
        end)
    else
        cb({})
    end
end)

RegisterNetEvent('rpa-garages:server:UpdateState', function(plate, state)
    local src = source
    local Player = GetPlayer(src)
    
    if not Player then return end
    
    -- Verify ownership before updating
    local citizenid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', { plate, citizenid }, function(result)
        if result and #result > 0 then
            MySQL.update('UPDATE player_vehicles SET state = ? WHERE plate = ?', { state, plate })
        else
            exports['rpa-lib']:Notify(src, "You don't own this vehicle", "error")
        end
    end)
end)
