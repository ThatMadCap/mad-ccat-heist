fx_version 'cerulean'
game 'gta5'

-- Github: https://github.com/ThatMadCap
-- Discord: '.madcap'

author 'MadCap'
description 'CCAT USB Heist'
version '1.0'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

lua54 'yes'