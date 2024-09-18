fx_version 'cerulean'
game 'gta5'

author 'Z'
description 'kewl weed script'
version '1.0.0'

lua54 'yes'

server_scripts {
    'server/server.lua'  -- Make sure the path is correct
}

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'qbx_core',
    'ox_inventory'
}
