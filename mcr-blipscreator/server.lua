ESX = exports['es_extended']:getSharedObject()

local adminGroups = Config and Config.AdminGroups or {'founder', 'management', 'admin'}
local allBlips = {}

local function loadBlips()
    local file = LoadResourceFile(GetCurrentResourceName(), 'blips.json')
    if file then
        allBlips = json.decode(file) or {}
    else
        allBlips = {}
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        loadBlips()
    end
end)

RegisterNetEvent('mcr-blipscreator:checkAdmin')
AddEventHandler('mcr-blipscreator:checkAdmin', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local isAdmin = false
    if xPlayer and xPlayer.getGroup then
        local group = xPlayer.getGroup()
        for _, adminGroup in ipairs(adminGroups) do
            if group == adminGroup then
                isAdmin = true
                break
            end
        end
    end
    TriggerClientEvent('mcr-blipscreator:adminResult', _source, isAdmin)
end)

RegisterNetEvent('mcr-blipscreator:saveBlip')
AddEventHandler('mcr-blipscreator:saveBlip', function(data)
    local src = source
    table.insert(allBlips, data)
    SaveResourceFile(GetCurrentResourceName(), 'blips.json', json.encode(allBlips, {indent=true}), -1)
    TriggerClientEvent('mcr-blipscreator:sendAllBlips', -1, allBlips)
end)

RegisterNetEvent('mcr-blipscreator:requestAllBlips')
AddEventHandler('mcr-blipscreator:requestAllBlips', function()
    local src = source
    TriggerClientEvent('mcr-blipscreator:sendAllBlips', src, allBlips)
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
end) 