fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MCore Development'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server.lua'
}

dependency 'es_extended'
dependency 'ox_lib'

files {
    'blips.json'
}
