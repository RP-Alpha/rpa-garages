local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('rpa-garages:server:GetVehicles', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        MySQL.query('SELECT * FROM player_vehicles WHERE citizenid = ?', { Player.PlayerData.citizenid }, function(result)
            cb(result or {})
        end)
    else
        cb({})
    end
end)

RegisterNetEvent('rpa-garages:server:UpdateState', function(plate, state)
    MySQL.update('UPDATE player_vehicles SET state = ? WHERE plate = ?', { state, plate })
end)
