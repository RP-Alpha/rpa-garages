Config = {}

--[[
    ==========================================
    PERMISSIONS
    ==========================================
    
    server.cfg examples:
    setr rpa_garages:admin "steam:110000123456789,license:abc123"
    setr rpa_garages:impound "steam:110000987654321"
]]

-- Who can use garage admin commands
Config.AdminPermissions = {
    groups = {'admin', 'god'},
    resourceConvar = 'admin'
}

-- Who can impound vehicles
Config.ImpoundPermissions = {
    groups = {'admin', 'god', 'mod'},
    jobs = {'police', 'bcso', 'sasp'},
    minGrade = 0,
    onDuty = true,
    resourceConvar = 'impound'
}

-- Who can release impounded vehicles (admins only by default)
Config.ReleaseImpoundPermissions = {
    groups = {'admin', 'god'},
    jobs = {'police'},
    minGrade = 3,
    resourceConvar = 'release_impound'
}

Config.Garages = {
    ['legion_public'] = {
        label = "Legion Square Public Garage",
        type = "public",
        ped = {
            model = 's_m_m_valet_01',
            coords = vector4(216.0, -809.0, 30.7, 250.0)
        },
        spawnPoint = vector4(222.0, -805.0, 30.6, 250.0)
    },
    ['pillbox_public'] = {
        label = "Pillbox Hill Public Garage",
        type = "public",
        ped = {
            model = 's_m_m_valet_01',
            coords = vector4(276.0, -345.0, 44.9, 250.0)
        },
        spawnPoint = vector4(272.0, -342.0, 44.9, 160.0)
    }
}
