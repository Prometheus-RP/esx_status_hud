fx_version 'adamant'

game 'gta5'

description 'ESX Status Hud'

version '1.0.0'
server_script 'server/main.lua'

client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'client/main.lua',
}

ui_page 'status_hud/dist/index.html'

files {
	'status_hud/dist/index.html'
}

shared_script 'config.lua'

dependencies {
	'es_extended',
	'esx_status',
	'esx_ambulancejob',
}