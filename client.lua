-- QBCore Exports / Variables
local QBCore = exports['qb-core']:GetCoreObject()
local GateHacked = false
local BackDoorHacked = false
local SingleUSBHacked = false
local MultipleUSBHacked = false

-- Skills ----------------------------------------------------------

function CheckSkill(skillType, skillValue)
    local hasEnough = false
    exports["mz-skills"]:CheckSkill(skillType, skillValue, function(hasSkill)
        if hasSkill then
            hasEnough = true
        end
    end)
    return hasEnough
end

-- Wrappers ----------------------------------------------------------

-- HasItem wrapper
--- @param items table | array | string
--- @param amount number | nil
--- @return boolean
function HasItem(items, amount)
    return QBCore.Functions.HasItem(items, amount)
end

-- Notify wrapper
local function Notify(text, level)
    exports["ps-ui"]:Notify(text, level)
end

-- Dispatch wrapper
local function Dispatch()
    exports["ps-dispatch"]:CCATHeist()
end

-- Webhook wrapper
local function SendWebhook()
    ped = PlayerPedId()
    local playerid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))

    --TriggerServerEvent("mad-ccat-heist:server:logging", playerid)
    -- Enter your own log if needed
end

-- Event handler for resource start
AddEventHandler("onResourceStart", function(name)
        Wait(1000)
        if name == GetCurrentResourceName() then
            -- <3
            print("^9<3 ^4Madcap CCAT Heist ^9<3")

            -- Close the PD Gate
            TriggerServerEvent("mad-ccat-heist:server:closedoor", "mad-ccat-heist:gabz_lamesapd_cargate")
            -- Close the PD Back Door
            TriggerServerEvent("mad-ccat-heist:server:closedoor", "mad-ccat-heist:gabz_lamesapd_doors02_entranceb")

            -- Check for xp
            --HasEnoughXPForMultipleUSBs()
        end
    end
)

-- Server Sync ----------------------------------------------------------

function IsHeistDone()
    return lib.callback.await('ccat:server:checkIsDone', false)
end

function IsHeistBeingHit()
    return lib.callback.await('ccat:server:checkIsBeingHit', false)
end

-- Qb-Targets ----------------------------------------------------------

-- FIRST HACK OUTSIDE GATE
exports["qb-target"]:AddCircleZone(
    "mad-ccat-heist-hack1",
    vector3(810.49, -1330.28, 25.95),
    1.0,
    {
        name = "mad-ccat-heist-hack1",
        debugPoly = Config.Debug,
        useZ = true
    },
    {
        options = {
            {
                type = "client",
                event = "mad-ccat-heist:client:HackGate",
                icon = "fa-brands fa-usb",
                label = "Hack the PD Gate",
                item = "trojan_usb"
            }
        },
        distance = 1.5
    }
)

-- SECOND HACK (BACK DOOR)
exports["qb-target"]:AddCircleZone(
    "mad-ccat-heist-hack2",
    vector3(858.35, -1320.16, 28.41),
    1.0,
    {
        name = "mad-ccat-heist-hack2",
        debugPoly = Config.Debug,
        useZ = true
    },
    {
        options = {
            {
                type = "client",
                event = "mad-ccat-heist:client:HackBackDoor",
                icon = "fa-solid fa-bomb",
                label = "Place Thermite",
                item = "thermite"
            }
        },
        distance = 1.5
    }
)

-- Define the ccatTransferOptions table with only the "Extract 1 USB" option
local ccatTransferOptions = {
    {
        type = "client",
        event = "mad-ccat-heist:client:CCATHackSingle",
        icon = "fa-solid fa-file-export",
        label = "Download Single CCAT Firmware",
        item = "radiousb"
    },
    {
        type = "client",
        event = "mad-ccat-heist:client:CCATHackMultiple",
        icon = "fa-solid fa-file-export",
        label = "Bulk Download CCAT Firmware Repository",
        canInteract = function()
            return CheckSkill('Hacking', Config.Skills.RequiredForMultipleUSB)
        end,
        item = "radiousb"
    }
}

-- Add the circle zone
exports["qb-target"]:AddCircleZone(
    "mad-ccat-heist-pdhack",
    vector3(852.95, -1292.24, 28.14),
    0.25,
    {
        name = "mad-ccat-heist-pdhack",
        debugPoly = Config.Debug,
        useZ = true
    },
    {
        options = ccatTransferOptions,
        distance = 1.5
    }
)

-- Hacks ----------------------------------------------------------

-- START HACK (PD GATE)
local function HackGate()

    if IsHeistDone() then
        Notify("System Offline", "error")
        return
    end

    -- Check for on duty cops and door status
    QBCore.Functions.TriggerCallback("mad-ccat-heist:server:policecount", function(policeCount)
        --[[ print("Police count: " .. policeCount)
        print("Required police: " .. Config.Heist.RequiredPolice)
        print("GateHacked: " .. tostring(GateHacked)) ]]
        if policeCount >= Config.Heist.RequiredPolice and GateHacked == false then

            -- Start the glow "spot" minigame
            exports["glow_minigames"]:StartMinigame(function(success)

                if success then
                    -- Open the PD Gate
                    TriggerServerEvent("mad-ccat-heist:server:opendoor", "mad-ccat-heist:gabz_lamesapd_cargate")

                    -- Set a variable for the door state
                    GateHacked = true

                    -- Notify
                    Notify("Outer Security System bypassed - Gate unlocked", "success")

                    -- Take hack item
                    TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "trojan_usb", 1)

                    -- give hacking xp
                    local GateHackXPGain = Config.Skills.GateHackXPGain
                    exports["mz-skills"]:UpdateSkill("Hacking", GateHackXPGain)

                else
                    -- Notify
                    Notify("Failed - Security System bypass unsuccessful", "error")

                    -- Take hack item
                    TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "trojan_usb", 1)

                    -- remove hacking xp
                    local GateHackXPLoss = -Config.Skills.GateHackXPLoss
                    exports["mz-skills"]:UpdateSkill("Hacking", GateHackXPLoss)
                end
            end, "path", {
                gridSize = Config.Minigames.Hack1.gridSize,
                lives = Config.Minigames.Hack1.lives,
                timeLimit = Config.Minigames.Hack1.timeLimit
            })
        else
            if GateHacked then
                Notify("Security System Offline", "error")
            else
                Notify("Not enough police", "error")
            end
        end
    end)
end

-- Register the event
RegisterNetEvent("mad-ccat-heist:client:HackGate", HackGate)

-- NEXT HACK (PD BACK DOOR)
local function HackBackDoor()

    if IsHeistDone() then
        Notify("System Offline", "error")
        return
    end

    -- If the first hack is done then allow us to hack the next door
    if GateHacked then

        if BackDoorHacked then
            Notify("Security Offline", "error")
            return
        end

        local hasItem = HasItem("lighter")
        if hasItem then

            -- thermite stuff
            if inAnimation then return end
            inAnimation = true

            TaskTurnPedToFaceCoord(PlayerPedId(), 858.35, -1320.16, 28.41, 1000)
            TaskGoStraightToCoord(PlayerPedId(), 858.37, -1320.58, 27.25, 1.0, -1, 0.0, 0.0)

            Wait(2000)

            lib.hideTextUI()
            lib.requestAnimDict('anim@heists@ornate_bank@thermal_charge')
            lib.requestModel('hei_p_m_bag_var22_arm_s')
            local playerPed = PlayerPedId()
            local fwd, _, _, pos = GetEntityMatrix(playerPed)
            local np = (fwd * 0.5) + pos
            SetEntityCoords(playerPed, np.xy, np.z - 1)
            local rot, pos = GetEntityRotation(playerPed), GetEntityCoords(playerPed)
            SetPedComponentVariation(playerPed, 5, -1, 0, 0)
            local doorObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 3.0, `v_ilev_fingate`, false, false, false)
            local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, pos.x, pos.y, pos.z,  true,  true, false)
            local scene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
            SetEntityCollision(bag, 0, 1)
            NetworkAddPedToSynchronisedScene(playerPed, scene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
            SetPedComponentVariation(playerPed, 5, 45, 0, 0)
            NetworkStartSynchronisedScene(scene)
            Wait(1500)
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local thermite = CreateObject(`hei_prop_heist_thermite`, x, y, z + 0.2,  true,  true, true)
            SetEntityCollision(thermite, false, true)
            AttachEntityToEntity(thermite, playerPed, GetPedBoneIndex(playerPed, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
            Wait(700)
            DetachEntity(thermite, 1, 1)
            FreezeEntityPosition(thermite,true)
            AttachEntityToEntity(thermite, doorObject, 1, 0, 0, 0, 0, 0, 0, true, true, false, false, 1, true)
            Wait(3300)
            DeleteObject(bag)
            NetworkStopSynchronisedScene(scene)

            -- Start the glow "spot" minigame
            exports['ps-ui']:Thermite(function(success)
                if success then -- minigame success
                    BackDoorHacked = true
                    -- thermite continue
                    TriggerServerEvent('mad-ccat-heist:thermiteFx', NetworkGetNetworkIdFromEntity(thermite), GetEntityCoords(thermite))
                    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
                    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
                    Wait(4000)
                    ClearPedTasks(ped)
                    Wait(2000)

                    -- Open the PD Gate
                    TriggerServerEvent("mad-ccat-heist:server:opendoor", "mad-ccat-heist:gabz_lamesapd_doors02_entranceb")
                    -- Notify
                    Notify("Building Security System bypassed - Door unlocked", "success")

                    -- Take hack item
                    TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "thermite", 1)

                    -- give hacking xp
                    local ThermiteHackXPGain = Config.Skills.ThermiteHackXPGain
                    exports["mz-skills"]:UpdateSkill("Hacking", ThermiteHackXPGain)

                    -- Check for xp
                    --HasEnoughXPForMultipleUSBs()

                else
                    -- Notify
                    Notify("Failed - Building Security System bypass unsuccessful", "error")

                    -- Take hack item
                    TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "thermite", 1)

                    -- remove hacking xp
                    local ThermiteHackXPLoss = -Config.Skills.ThermiteHackXPLoss
                    exports["mz-skills"]:UpdateSkill("Hacking", ThermiteHackXPLoss)

                    -- thermite stuff
                    DeleteEntity(thermite)
                    Wait(1000)
                    inAnimation = false
                end
            end,
            Config.Minigames.Hack2.time,
            Config.Minigames.Hack2.gridSize,
            Config.Minigames.Hack2.incorrectBlocks)
        else -- no lighter
            Notify("You're missing an ignition source", "error")
        end
        else -- the first hack isn't done
            Notify("Outer Security System Online", "error")
        end
end

-- Register the event
RegisterNetEvent("mad-ccat-heist:client:HackBackDoor", HackBackDoor)

-- thermite event
RegisterNetEvent('mad-ccat-heist:thermiteFx', function(netId,coords)
    if #(GetEntityCoords(PlayerPedId()) - coords) < 40.0 then
        local thermite = NetworkGetEntityFromNetworkId(netId)
        if not DoesEntityExist(thermite) then return end
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Wait(1)
        end
        SetPtfxAssetNextCall("scr_ornate_heist")
        local rot = GetEntityRotation(thermite)
        local Effect = StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn", thermite, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Wait(8000)
        StopParticleFxLooped(Effect, 0)
        if DoesEntityExist(thermite) then
            DeleteEntity(thermite)
        end
    end
end)

-- CCAT Firmware Hacks

local function CCATHackSingle()

    if IsHeistDone() then
        Notify("System Offline", "error")
        return
    end

    if IsHeistBeingHit() then
        Notify("System Occupied", "error")
        return
    end

    -- TODO: REMOVE (ONLY FOR TEST TO BYPASS HACKS)
    --[[ local GateHacked = true
    local BackDoorHacked = true ]]

    if not GateHacked then
        Notify("Outer Security System must be bypassed first", "error")
        return
    end

    if not BackDoorHacked then
        Notify("Building Security System must be bypassed first", "error")
        return
    end

    if SingleUSBHacked or MultipleUSBHacked then
        Notify("System Offline", "error")
        return
    end

    local hasItem = HasItem("blank_usb")
    if not hasItem then
        Notify("You're missing a Blank USB", "error")
        return
    end

    -- Start math minigame
    TriggerServerEvent('mad-ccat-heist:server:updateBeingHit', true)
    exports["glow_minigames"]:StartMinigame(function(success)
        if success then
            SendWebhook()
            TriggerServerEvent('mad-ccat-heist:server:setheist', true)
            TriggerServerEvent('mad-ccat-heist:server:updateBeingHit', false)

            local CCATHackingXPGainSingle = Config.Skills.CCATHackingXPGainSingle
            exports["mz-skills"]:UpdateSkill("Hacking", CCATHackingXPGainSingle)

            SingleUSBHacked = true
            WaittoGiveSingleRewards()

            -- Remove the zone after a minute if it's not been used 
            Citizen.CreateThread(function()
                Citizen.Wait(1000 * Config.Timers.USBPullOutTime) -- Wait for 1 minute
                exports["qb-target"]:RemoveZone("mad-ccat-heist-hack3")
                Notify("System Locked", "error")
            end)
        else
            TriggerServerEvent('mad-ccat-heist:server:updateBeingHit', false)
            SendWebhook()
            Notify("Failed - CCAT Firmware Corrupted", "error")

            local CCATHackingXPLossSingle = -Config.Skills.CCATHackingXPLossSingle
            exports["mz-skills"]:UpdateSkill("Hacking", CCATHackingXPLossSingle)

            -- Take blank usb
            TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 1)
        end
    end, "math", {
        timeLimit = Config.Minigames.Hack3.timeLimit * 60 * 1000, -- convert to minutes
        operators = Config.Minigames.Hack3.operators
    })
end

-- Register the event
RegisterNetEvent("mad-ccat-heist:client:CCATHackSingle", CCATHackSingle)

local function CCATHackMultiple()

    if IsHeistDone() then
        Notify("System Offline", "error")
        return
    end

    -- TODO: REMOVE (ONLY FOR TEST TO BYPASS HACKS)
    --[[ local GateHacked = true
    local BackDoorHacked = true ]]

    if not GateHacked then
        Notify("Outer Security System must be bypassed first", "error")
        return
    end

    if not BackDoorHacked then
        Notify("Building Security System must be bypassed first", "error")
        return
    end

    if MultipleUSBHacked or SingleUSBHacked then
        Notify("System Offline", "error")
        return
    end

    local has1Item = HasItem("blank_usb", 1)
    if not has1Item then
        Notify("You're missing a Blank USB", "error")
        return
    end

    local has2Items = HasItem("blank_usb", 2)
    if not has2Items then
        Notify("You need at least 2 Blank USBs", "error")
        return
    end

    -- Start math minigame
    exports["glow_minigames"]:StartMinigame(function(success)
        if success then
            TriggerServerEvent('mad-ccat-heist:server:setheist', true)
            SendWebhook()
            Dispatch()

            local CCATHackingXPGainMultiple = Config.Skills.CCATHackingXPGainMultiple
            exports["mz-skills"]:UpdateSkill("Hacking", CCATHackingXPGainMultiple)

            MultipleUSBHacked = true
            WaittoGiveMultipleRewards()

            -- Remove the zone after a minute if it's not been used 
            Citizen.CreateThread(function()
                Citizen.Wait(1000 * Config.Timers.USBPullOutTime) -- Wait for 1 minute
                exports["qb-target"]:RemoveZone("mad-ccat-heist-hack4")
                Notify("System Locked", "error")
            end)
        else
            SendWebhook()
            Notify("Failed - CCAT Firmware Corrupted", "error")

            local CCATHackingXPLossMultiple = -Config.Skills.CCATHackingXPLossMultiple
            exports["mz-skills"]:UpdateSkill("Hacking", CCATHackingXPLossMultiple)

            -- Take blank usb
            TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 1)
        end
    end, "math", {
        timeLimit = Config.Minigames.Hack4.timeLimit * 60 * 1000, -- convert to minutes
        operators = Config.Minigames.Hack4.operators
    })
end

-- Register the event
RegisterNetEvent("mad-ccat-heist:client:CCATHackMultiple", CCATHackMultiple)

-- Rewards ----------------------------------------------------------

function MultipleRewards()
    local has1blank = HasItem("blank_usb", 1)
    local has2blank = HasItem("blank_usb", 2)
    local has3blank = HasItem("blank_usb", 3)
    local has4blank = HasItem("blank_usb", 4)
    local has5blank = HasItem("blank_usb", 5)
    -- Take Blank USBs + Give RadioUSBs
    if has5blank then
        TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 5)
        TriggerServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', 5)
    elseif has4blank then
        TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 4)
        TriggerServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', 4)
    elseif has3blank then
        TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 3)
        TriggerServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', 3)
    elseif has2blank then
        TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 2)
        TriggerServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', 2)
    elseif has1blank then
        TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 1)
        TriggerServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', 1)
    end
end

function WaittoGiveSingleRewards()
    Citizen.CreateThread(function()
        Notify("Please wait " .. Config.Timers.SingleUSB .. " seconds for the download to complete", "primary")
        Citizen.Wait(1000 * Config.Timers.SingleUSB)
        Notify("Download Complete. USB ready for collection", "success")

        exports["qb-target"]:AddCircleZone(
        "mad-ccat-heist-hack3",
        vector3(852.76, -1292.71, 27.55),
        0.5,
        {
            name = "mad-ccat-heist-retrieve-usbs",
            debugPoly = Config.Debug,
            useZ = true
        },
        {
            options = {
                {
                    type = "server",
                    event = "mad-ccat-heist:server:GiveRewardsCCATHackSingle",
                    icon = "fa-solid fa-hand",
                    label = "Retrieve Single USB",
                    item = "radiousb",
                    action = function()
                        local hasItem = HasItem("blank_usb")
                        if hasItem then
                            -- Take blank usb
                            TriggerServerEvent('mad-ccat-heist:server:RemoveItem', "blank_usb", 1)
                            -- Give single usb reward
                            TriggerServerEvent("mad-ccat-heist:server:GiveRewardsCCATHackSingle")
                            -- Remove the zone after it's been triggered
                            exports["qb-target"]:RemoveZone("mad-ccat-heist-hack3")
                        else
                            Notify("You're missing a Blank USB", "error")
                        end
                    end
                },
            },
            distance = 2.5
        })
    end)
end

function WaittoGiveMultipleRewards()
    Citizen.CreateThread(function()

        Notify("Please wait " .. Config.Timers.MultipleUSB .. " seconds for the download to complete", "primary")
        Citizen.Wait(1000 * Config.Timers.MultipleUSB)
        Notify("Download Complete. USBs ready for collection", "success")

        exports["qb-target"]:AddCircleZone(
        "mad-ccat-heist-hack4",
        vector3(852.76, -1292.71, 27.55),
        0.5,
        {
            name = "mad-ccat-heist-retrieve-usbs",
            debugPoly = Config.Debug,
            useZ = true
        },
        {
            options = {
                {
                    type = "server",
                    event = "mad-ccat-heist:server:GiveRewardsCCATHackSingle",
                    icon = "fa-solid fa-hand",
                    label = "Retrieve Multiple USBs",
                    item = "radiousb",
                    action = function()

                        local has1Item = HasItem("blank_usb", 1)
                        if has1Item then

                            local has2Items = HasItem("blank_usb", 2)
                            if has2Items then

                                -- Give multiple rewards
                                MultipleRewards()

                                -- Remove the zone after it's been triggered
                                exports["qb-target"]:RemoveZone("mad-ccat-heist-hack4")

                                else
                                    Notify("You need at least 2 Blank USBs", "error")
                                end

                            else
                                Notify("You're missing a Blank USB", "error")
                            end
                    end
                },
            },
            distance = 2.5
        })
    end)
end
