-- QBCore Exports & Variables
local QBCore = exports['qb-core']:GetCoreObject()
local isDone = false
local isBeingHit = false

-- Resource start -------------------------------------------------------------------

local function OnStart(resource)
    if (GetCurrentResourceName() ~= resource) then
        return
    end
    print(resource .. ' started successfully')
end

-- Police Count -------------------------------------------------------------------

-- Police Count Callback
--- Retrieves the number of police officers currently on duty.
---@param source number The source of the request.
---@param callback function The function to receive the police count.
function PoliceCount(source, callback)
    local Player_ids = QBCore.Functions.GetPlayers()
    local police_count = 0
    for i = 1, #Player_ids do
        local Player = QBCore.Functions.GetPlayer(Player_ids[i])
        if Player and Player.PlayerData.job and Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            police_count = police_count + 1
        end
    end
    callback(police_count) -- Return the actual police count
end

QBCore.Functions.CreateCallback("mad-ccat-heist:server:policecount", PoliceCount)


-- Webhook -------------------------------------------------------------------

-- Enter your own log if needed

--[[ RegisterNetEvent('mad-ccat-heist:server:logging', function(playerid)
    local Player = QBCore.Functions.GetPlayer(playerid)
    local RobberName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    local RobberDiscord = QBCore.Functions.GetIdentifier(playerid, 'discord'):sub(9)
    local RobberLocation = tostring(QBCore.Functions.GetCoords(GetPlayerPed(playerid)))

    if (playerid) then
        TriggerEvent("yume-log:server:CreateLog",
        "mad-ccat-heist", -- name
        "mad-ccat-heist", -- title
        "red", -- color
        false, -- tagEveryone
        "<@" .. RobberDiscord .. "> **" .. RobberName .. "** attempted the **[CCAT Heist]** at **" .. RobberLocation .. "**",
        "Player",
        nil,
        nil)
    end
end) ]]

-- Thermite -------------------------------------------------------------------

-- thermite event
RegisterServerEvent('mad-ccat-heist:thermiteFx', function(netId,coords)
    TriggerClientEvent('mad-ccat-heist:thermiteFx',-1,netId,coords)
end)

-- Doors -------------------------------------------------------------------

-- Register the OpenDoor event
RegisterNetEvent("mad-ccat-heist:server:opendoor", function(doorid)
        local src = source
        TriggerClientEvent("qb-doorlock:client:setState", -1, src, doorid, false, false, false, false)
    end
)

-- Register the CloseDoor event
RegisterNetEvent("mad-ccat-heist:server:closedoor", function(doorid)
        local src = source
        TriggerClientEvent("qb-doorlock:client:setState", -1, src, doorid, true, false, false, false)
    end
)

-- Items -------------------------------------------------------------------

-- Remove Item
local function RemoveItem(item, quantity)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(item, quantity)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", quantity)
end

-- Give Rewards
local function GiveRewardsCCATHackSingle()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("radiousb", 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["radiousb"], "add", 1)
    TriggerClientEvent('QBCore:Notify', source, "CCAT Firmware Loaded", 'success')
end

local function GiveRewardsCCATHackMultiple(quantity)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("radiousb", quantity)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["radiousb"], "add", quantity)
    TriggerClientEvent('QBCore:Notify', source, "CCAT Firmware Repository Loaded", 'success')
end

-- Server sync ----------------------------------------------------------------------------

RegisterNetEvent('mad-ccat-heist:server:setheist', function(retval)
    isDone = retval
end)

RegisterNetEvent('mad-ccat-heist:server:updateBeingHit', function(retval)
    isBeingHit = retval
end)

lib.callback.register('ccat:server:checkIsDone', function(source)
    return isDone
end)

lib.callback.register('ccat:server:checkIsBeingHit', function(source)
    return isBeingHit
end)

-- Registration follows ----------------------------------------------------------------------------

-- Remove Item Server Event
RegisterServerEvent('mad-ccat-heist:server:RemoveItem', RemoveItem)

-- Event Handler for Resource Start
AddEventHandler('onResourceStart', OnStart)

-- Add Rewards Server Events
RegisterServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackSingle', GiveRewardsCCATHackSingle)
RegisterServerEvent('mad-ccat-heist:server:GiveRewardsCCATHackMultiple', GiveRewardsCCATHackMultiple)