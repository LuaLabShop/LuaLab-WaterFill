fx_version 'cerulean'
game 'gta5'

description 'LuaLab-WaterFill - Water Bottle System'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'stream/bottle_blue.ydr',
    'stream/bottle_blue.ytyp',
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bottle_blue.ytyp'

ui_page 'html/index.html'

lua54 'yes' 

escrow_ignore {
    'README.md',
    'config.lua',
    'client/main.lua',
    'server/main.lua',
    'stream/bottle_blue.ydr',
    'stream/bottle_blue.ytyp',
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'qb-inventory/html/js/app.js',
    'qb-inventory/items.lua',
    'qb-inventory/images/metal_bottle.png',
    'qb-inventory/images/metal_bottle2.png'
  }