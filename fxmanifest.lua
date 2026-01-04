fx_version 'cerulean'
game 'gta5'

author 'RP-Alpha'
description 'RP-Alpha Garage System'
version '1.0.0'

dependencies {
    'rpa-lib',
    'rpa-vehiclekeys',
    'oxmysql'
}

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

lua54 'yes'
