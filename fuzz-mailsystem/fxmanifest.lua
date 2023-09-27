fx_version 'cerulean'
game 'gta5'

author 'Fuzziegoon'
description 'fuzz-mailsystem'

lua54 "yes"




shared_scripts {
    "config.lua",
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
}

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}
   

