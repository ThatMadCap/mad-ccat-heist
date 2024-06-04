# mad-ccat-heist

![ccat-heist-banner](https://github.com/ThatMadCap/mad-ccat-heist/assets/95227673/d4f9fae9-0d84-410a-8df6-ae18668221f6)

<a href="https://ko-fi.com/madcap" target="_blank"><img src="https://assets-global.website-files.com/5c14e387dab576fe667689cf/64f1a9ddd0246590df69ea0b_kofi_long_button_red%25402x-p-500.png" alt="Support me on Ko-fi" width="250"></a>

# Introduction

Break into a police department to clone a copy of some federal software. Options to complete the heist "quiet" or "loud". Intended to compliment [V7-RadioHack](https://github.com/V7-DEV/V7-RadioHack) by giving players a unique heist to clone the USB required.

## Preview
[Youtube](https://youtu.be/_8Hql9-SKfk)

## Dependencies
* Gabz La Mesa PD MLO
* [qb-core](https://github.com/qbcore-framework/qb-core)
* [qb-doorlock](https://github.com/qbcore-framework/qb-core)
* [qb-target](https://github.com/qbcore-framework/qb-core)
* [ox-lib](https://github.com/overextended/ox_lib)
* [ps-ui](https://github.com/Project-Sloth/ps-ui)
* [glow_minigames](https://github.com/christikat/glow_minigames)
* [mz-skills](https://github.com/MrZainRP/mz-skills) for skill gain/loss on hacking success/fail
* [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch) for police alerts
* [V7-RadioHack](https://github.com/V7-DEV/V7-RadioHack) if you want to give the same item, otherwise not needed
* Resource tested using qb-inventory/lj-inventory

## Item

Add this to your shared items:

```lua
-- radio hack
["radiousb"]                        = {["name"] = "radiousb",                     ["label"] = "CCAT USB",                 ["weight"] = 100,         ["type"] = "item",         ["image"] = "RadioUSB.png",             ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,       ["combinable"] = nil,   ["description"] = "USB loaded with Covert Channel Access Tool."},
-- blank usb
["blank_usb"] = {["name"] = "blank_usb", ["label"] = "Blank USB", ["weight"] = 100, ["type"] = "item", ["image"] = "usb_device.png", ["unique"] = false, ["useable"] = false, ["shouldClose"] = false, ["combinable"] = { accept = { 'gatecrack' }, reward = 'trojan_usb', anim = { dict = 'anim@amb@business@weed@weed_inspecting_high_dry@', lib = 'weed_inspecting_high_base_inspector', text = 'Loading USB with Trojan Software', timeOut = 7500, } }, ["description"] = "This blank USB stick could be turned into anything in a professional's hands..."},
```

## ps-dispatch

Add this to your alerts.lua
```lua
-- mad-ccat-heist
local function CCATHeist()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = 'La Mesa PD Alarm',
        codeName = 'ccatheist',
        code = '10-90',
        icon = 'fa-solid fa-computer',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        alertTime = 10,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CCATHeist', CCATHeist)
```
config.lua
```lua
    -- Data Heist
    ['ccatheist'] = {
        radius = 0,
        sprite = 606,
        color = 1,
        scale = 1.5,
        length = 3,
        sound = 'robberysound',
        offset = false,
        flash = false
    },
```

## Doorlock

- use this for "lamesapd.lua" doorlock config
```lua

-- Front left entrance - doorname: gabz_lamesapd_doors01_entrancea
--[[ table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(827.9521, -1288.786, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = 277920071,
	maxDistance = 2.0,
	objHeading = 89.999977111816,
	audioRemote = false,
	slides = false,
	locked = true,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Front right entrance - doorname: gabz_lamesapd_doors01_entranceb
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(827.9521, -1291.387, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -34368499,
	maxDistance = 2.0,
	objHeading = 269.99987792969,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
}) ]]

--Front entrance -
table.insert(Config.DoorList, {
    distance = 3,
    doorType = 'double',
    doorLabel = 'Front Entrance',
    doors = {
        {objName = 277920071, objYaw = 89.999977111816, objCoords = vec3(827.951965, -1288.785889, 28.371161)},
        {objName = -34368499, objYaw = 269.99987792969, objCoords = vec3(827.951965, -1291.386475, 28.371161)}
    },
    authorizedJobs = { ['police'] = 0 },
    locked = true,
    doorRate = 1.0,
})

-- Observation - doorname: gabz_lamesapd_doors03_observation
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(840.0884, -1280.999, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -1011300766,
	maxDistance = 2.0,
	objHeading = 269.99996948242,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Interrogation - doorname: gabz_lamesapd_doors03_interogation
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(840.0861, -1281.824, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -1189294593,
	maxDistance = 2.0,
	objHeading = 89.999977111816,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Left entrance meetingroom (left door) - doorname: gabz_lamesapd_doors01_meetinga
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(849.9325, -1287.346, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -1983352576,
	maxDistance = 2.0,
	objHeading = 179.99984741211,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Left entrance meetingroom (right door) - doorname: gabz_lamesapd_doors01_meetingb
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(852.5331, -1287.346, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = 2076628221,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Right entrance meetingroom (left door) - doorname: gabz_lamesapd_doors01_meetinga
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(856.5074, -1287.346, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -1983352576,
	maxDistance = 2.0,
	objHeading = 179.99984741211,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Right entrance meetingroom (right door) - doorname: gabz_lamesapd_doors01_meetingb
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(859.1082, -1287.346, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = 2076628221,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Archives - doorname: gabz_lamesapd_doors01_archives
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(858.865, -1291.385, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = 539497004,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Cpt.Office - doorname: gabz_lamesapd_doors01_office
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(851.9497, -1298.389, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = 1861900850,
	maxDistance = 2.0,
	objHeading = 89.999862670898,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Cell - doorname: gabz_lamesapd_doors01_cell
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(834.2814, -1295.986, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = 1162089799,
	maxDistance = 2.0,
	objHeading = 89.999977111816,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Lobby fence door - doorname: gabz_lamesapd_fancegate
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(835.9445, -1292.193, 27.78268),
	authorizedJobs = { ['police']=0 },
	objHash = -147896569,
	maxDistance = 2.0,
	objHeading = 270.00003051758,
	audioRemote = false,
	slides = false,
	locked = true,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Breakroom - doorname: gabz_lamesapd_doors01_breakroom
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(837.2611, -1309.514, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = 1491736897,
	maxDistance = 2.0,
	objHeading = 269.99996948242,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Evidence - doorname: gabz_lamesapd_doors01_evidences
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(846.3696, -1310.04, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = 272264766,
	maxDistance = 2.0,
	objHeading = 179.99995422363,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Lockers1 - doorname: gabz_lamesapd_doors02_lockers
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(854.7811, -1310.04, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = -1213101062,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Lockers2 - doorname: gabz_lamesapd_doors02_lockers
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(855.7422, -1314.608, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = -1213101062,
	maxDistance = 2.0,
	objHeading = 269.99993896484,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Hallway to openspace (Left door) - doorname: gabz_lamesapd_doors02
--[[ table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(856.5074, -1310.038, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -375301406,
	maxDistance = 2.0,
	objHeading = 179.99984741211,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Hallway to openspace (Right door) - doorname: gabz_lamesapd_doors02
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(859.1082, -1310.038, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -375301406,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = false,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
}) ]]

-- Hallway to openspace
table.insert(Config.DoorList, {
    locked = false,
    distance = 3,
    authorizedJobs = { ['police'] = 0 },
    doorLabel = 'Hallway',
    doors = {
        {objName = -375301406, objYaw = 0.0, objCoords = vec3(859.108032, -1310.037476, 28.371161)},
        {objName = -375301406, objYaw = 179.99984741211, objCoords = vec3(856.507324, -1310.037476, 28.371161)}
    },
    doorType = 'double',
    doorRate = 1.0,
})

-- Backentrance to hallway - doorname: gabz_lamesapd_doors02_entranceb
Config.DoorList['mad-ccat-heist:gabz_lamesapd_doors02_entranceb'] = {
    authorizedJobs = { ['police'] = 0 },
    fixText = false,
    locked = true,
    objCoords = vec3(859.007446, -1320.124146, 28.371107),
    objYaw = 0.0,
    doorRate = 1.0,
    doorType = 'door',
    objName = -1339729155,
    distance = 3,
    doorLabel = 'Back Entrance',
}

-- Backentrance to hallway - doorname: gabz_lamesapd_doors02_entranceb
--[[ table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(859.0076, -1320.125, 28.37111),
	authorizedJobs = { ['police']=0 },
	objHash = -1339729155,
	maxDistance = 2.0,
	objHeading = 0.0,
	audioRemote = false,
	slides = false,
	locked = true,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
}) ]]

-- Backentrance to breakroom - doorname: gabz_lamesapd_doors02_entrancea
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(829.6385, -1310.128, 28.37117),
	authorizedJobs = { ['police']=0 },
	objHash = -1246730733,
	maxDistance = 2.0,
	objHeading = 179.99989318848,
	audioRemote = false,
	slides = false,
	locked = true,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- Parkinglot gate - doorname: gabz_lamesapd_cargate
Config.DoorList['mad-ccat-heist:gabz_lamesapd_cargate'] = {
    objCoords = vec3(816.986206, -1325.257812, 25.093277),
    locked = true,
    doorLabel = '1',
    fixText = false,
    doorType = 'sliding',
    authorizedJobs = { ['police'] = 0 },
    distance = 6,
    objYaw = 269.03561401367,
    doorRate = 1.0,
    objName = -1372582968,
}

-- Parkinglot gate - doorname: gabz_lamesapd_cargate
--[[ table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(816.9862, -1325.258, 25.09328),
	authorizedJobs = { ['police']=0 },
	objHash = -1372582968,
	maxDistance = 2.0,
	objHeading = 269.0,
	audioRemote = false,
	slides = false,
	locked = true,
	lockpick = false,
	fixText = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
}) ]]
```

#### Heist Summary 
* Use trojan_usb on electrical box outside La Mesa PD to hack the panel, opening the gate.
* Use thermite (with a lighter) on back door to break into the building.
* Hack the PD computer inside the archives room.
* After successful hack, use a number of blank_usb's to copy the data from exposed repository.
* Option to download ONE per heist attempt for a "quiet" heist, or MULTIPLE at one time for a "loud" heist.
* Important: players require at least ONE of the CCAT USBs in order to access the hack from the PD computer (how would you clone software without having a copy of it first). Bulk-download option (aka "loud" heist) requires players to wait 5 minutes for their download - ensuring PD/Crim negotiation roleplay.
* The system will then shut down after a few seconds - players must take their cloned USB(s) before then (no running away and coming back 2 hours later when no one is there).
* When cloning multiple USBs, the player can bring anywhere between 2-5 blank usbs and recieve that many copies.

##### Notes
The heist was originally written for my FiveM server and I had no plans on releasing it. The heist has been tested and works properly. It is intended to be used once per server restart, therefore includes no cooldown feature. The heist will sync its state with all players on load. The building has 2 outer security systems that require bypassing in order to access the final hack.

The resource was written to compliment [V7-RadioHack](https://github.com/V7-DEV/V7-RadioHack). Successfully completing the heist will give the player a radiousb, intended to use to begin the V7-RadioHack. At the time and within the story of my server La Mesa PD was an abandonded police department, so it made sense to have players break into it to on the sly to get their reward. If your server has the department as functional, you may want to edit the doorlock config provided.

The final hack for this is very difficult and the player is provided a lot of time to complete it. The math minigame from glow_minigames is used. If this is too hard for your players, consider using the edited version of glow-minigames that we have provided within this resource in the "INSTALL" folder. This edited version is slightly easier than the base math minigame, but will still take the average player a decent time to figure out.

#### Credits
Thanks to [Simon](https://github.com/simsonas86) for fixing my code <3
