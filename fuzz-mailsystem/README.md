# Mailman/Mailtheft Script which works with QBCore Framework
- <strong> fuzz-mailsystem </strong> <br>
A resource which allows players to steal money/packages from mailboxes and a working mail job. 
I would consider this an ultra fork, and it was my first go at "coding" <3


## Features
- You can choose item to steal mail
- Reward amounts are configurable. <br>
- Configurable Theft cooldown time. <br>
- Configurable police call chance. <br>
- Players cannot steal from the same mailboxes again & again (No Spamming). <br> <br>

# Dependencies #
01. qb-core - https://github.com/qbcore-framework/qb-core <br>
02. ps-ui - https://github.com/Project-Sloth/ps-ui <br>
03. ps-dispatch - https://github.com/Project-Sloth/ps-dispatch <br>
04. qb-target - https://github.com/qbcore-framework/qb-target
05. (OPTIONAL) USPS TRANSIT VAN - https://www.lcpdfr.com/downloads/gta5mods/vehiclemodels/33137-fivem-ready-2020-usps-ford-transit/


# Installation
01. Make sure that you have all the above dependancies in your server.
02. Download the resource.
03. Add these to your qb-core/shared/items.lua

['stolenpackage']             		= {['name'] = 'stolenpackage',                		['label'] = 'Stolen Box',       	['weight'] = 10000,         ['type'] = 'item',      ['image'] = 'small-box.png',     		['unique'] = true,      ['useable'] = true,     ['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'A box you stole, you piece of shit'},

['mailmancredentials']             		= {['name'] = 'mailmancredentials',                		['label'] = 'Postal Routes',       	['weight'] = 1000,         ['type'] = 'item',      ['image'] = 'certificate.png',     		    ['unique'] = true,      ['useable'] = false,     ['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Stolen Government Mail Credentials'},

['dirtybills'] 				 	= {['name'] = 'dirtybills', 			  	  	   ['label'] = 'Stolen Dollar Bill', 		['weight'] = 0, 		['type'] = 'item', 		['image'] = 'dirtybills.png', 			['unique'] = false, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Dollar per Dollar'},

['junkmail']             		   = {['name'] = 'junkmail',                		['label'] = 'Junk Mail',       	['weight'] = 500,         ['type'] = 'item',      ['image'] = 'junkmail.png',     		    ['unique'] = false,      ['useable'] = false,     ['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Mail that can be return to the post office'},


['boxcutter']             		= {['name'] = 'boxcutter',                		['label'] = 'Box Cutter',       	['weight'] = 500,         ['type'] = 'item',      ['image'] = 'boxcutter.png',     		    ['unique'] = true,      ['useable'] = false,     ['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'ITS A BOX CUTTER'},

04. Paste Images in inventory/html/images
05. Place it in in resources folder as you want.
06. Done.

# Credits
-Thanks to zf-labo for their dumpster script that was the base of the mail theft script!
https://github.com/zf-labo/zf-dumpster-qb
-Thanks to Randolio whos Pizza Job was the base of the mail delivery system!
https://github.com/Randolio/randol_pizzajob
-Thanks to Kevin for his sell ped script that was obviously the sell ped function 
https://github.com/KevinGirardx/kevin-sellped
-A final thanks to ImMacky for his wonderful gift box script that served as the function for opening stolen packages 
https://github.com/ImMacky/mk-GiftBox

## Contributors ##
- Quake - https://github.com/55thRPDev 
- Markow

## Planned Features 
- Item Requirement to steal from MailBoxes. 
- Add inventory popup box to show items taken from mail