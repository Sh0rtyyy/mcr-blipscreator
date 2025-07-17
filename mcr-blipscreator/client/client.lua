ESX = exports['es_extended']:getSharedObject()

local lastBlip = nil
local createdBlips = {}

local function safeBlipScale(size)
    size = tonumber(size) or 1.0
    if size < 0.1 then size = 0.1 end
    return size
end

local blipColors = {
    [0] = {255,255,255},   -- White
    [1] = {224, 50, 50},   -- Red
    [2] = {114, 204, 114}, -- Green
    [3] = {93, 182, 229},  -- Blue
    [5] = {240, 200, 80},  -- Yellow
    [7] = {132, 102, 226}, -- Purple
    [40] = {0,0,0},        -- Black
    [38] = {255, 140, 0},  -- Orange
    [46] = {255, 0, 255},  -- Pink
    [47] = {0, 255, 255},  -- Cyan
    [49] = {0, 0, 139},    -- Dark Blue
    [11] = {255, 255, 255} -- Light Gray
}

local function hexToRGB(hex)
    hex = hex:gsub('#','')
    return tonumber('0x'..hex:sub(1,2)), tonumber('0x'..hex:sub(3,4)), tonumber('0x'..hex:sub(5,6))
end

local function closestBlipColorIndex(hex)
    local r, g, b = hexToRGB(hex)
    local minDist, minIndex = math.huge, 0
    for idx, color in pairs(blipColors) do
        local dr, dg, db = r - color[1], g - color[2], b - color[3]
        local dist = dr*dr + dg*dg + db*db
        if dist < minDist then
            minDist = dist
            minIndex = idx
        end
    end
    return minIndex
end

RegisterNetEvent('mcr-blipscreator:sendAllBlips')
AddEventHandler('mcr-blipscreator:sendAllBlips', function(blips)
    for _, b in ipairs(createdBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    createdBlips = {}
    for _, blip in ipairs(blips) do
        local b = AddBlipForCoord(blip.x+0.0, blip.y+0.0, blip.z+0.0)
        SetBlipSprite(b, tonumber(blip.sprite) or 1)
        SetBlipDisplay(b, 4)
        SetBlipScale(b, safeBlipScale(blip.size))
        SetBlipColour(b, tonumber(blip.color) or 0)
        SetBlipAsShortRange(b, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blip.name or 'Blip')
        EndTextCommandSetBlipName(b)
        table.insert(createdBlips, b)
    end
end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('mcr-blipscreator:requestAllBlips')
end)

RegisterCommand(Config.AdminCommand, function()
    TriggerServerEvent('mcr-blipscreator:checkAdmin')
end, false)

RegisterNetEvent('mcr-blipscreator:adminResult')
AddEventHandler('mcr-blipscreator:adminResult', function(isAdmin)
    if isAdmin then
        local input = lib.inputDialog('Create Blip', {
            {type = 'input', label = 'Enter Blip Name', required = true},
            {type = 'input', label = 'Enter Blip ID', required = true},
            {type = 'color', label = 'Colour input', default = '#eb4034'},
            {type = 'input', label = 'Enter Blip Size', required = true, icon = 'ruler'}
        })
        if not input then return end
        local name, sprite, hexColor, size = input[1], tonumber(input[2]), tostring(input[3]), safeBlipScale(input[4])
        local color = closestBlipColorIndex(hexColor)
        lib.showTextUI('[E] Set blip location', {position = 'top-center', icon = 'fa-map-marker-alt'})
        CreateThread(function()
            while true do
                Wait(0)
                if IsControlJustReleased(0, 38) then -- E
                    lib.hideTextUI()
                    local coords = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent('mcr-blipscreator:saveBlip', {
                        name = name,
                        sprite = sprite,
                        color = color,
                        size = size,
                        x = coords.x,
                        y = coords.y,
                        z = coords.z
                    })
                    ESX.ShowNotification('Blip has been created!')
                    break
                end
            end
        end)
    else
        ESX.ShowNotification('You do not have permission to use this command!')
    end
end)