fx_version 'cerulean'
game 'gta5'
author 'Flexiboii'
description 'Vos Moneywash'
lua54 'yes'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config.lua',
    'client/bridge/*.lua',
    'server/bridge/*.lua',
}

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua',
}

server_scripts {
    'sv_config.lua',
    'server/**.lua',
}

files {
    'locales/*.json',
}

dependencies {
    'qbx_core',
    'ox_lib',
}