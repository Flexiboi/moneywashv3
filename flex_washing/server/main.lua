local missions = {}
local WEBHOOK_URL = ''

local function SendWebhook(title, description)
    if WEBHOOK_URL == "" or WEBHOOK_URL == nil then return end

    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["type"] = "rich",
            ["color"] = 3066993,
            ["footer"] = {
                ["text"] = "VOS",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(WEBHOOK_URL, function(err, text, headers) end, 'POST', json.encode({
        username = "VOS",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- @return all NPCS
lib.callback.register('flex_washing:server:GetDoors', function(source)
    return sv_config.doors
end)

-- @return if player has enough blackmoney
---@param which array
---@param index of the array
---@param amount of blackmoney
lib.callback.register('flex_washing:server:HasBlackMoney', function(source, confType, index, amount)
    local src = source
    local conf = sv_config[confType][index]

    local ped = GetPlayerPed(src)
    if not ped then return end
    if #(GetEntityCoords(ped) - conf.door.xyz) > 8.0 then return false end
    if amount > conf.maxWash then return false end
    if not HasInvGotItem(src, 'count', sv_config.dirtMoney, nil, amount) then return false end
    local player = GetPlayer(src)
    if not player then return end
    SendWebhook('DIRT MONEY', locale('discord.iswashingmoney', player?.PlayerData?.charinfo?.firstname..' '..player?.PlayerData?.charinfo?.lastname..' ('..player?.PlayerData?.citizenid..')', amount))
    if RemoveItem(src, sv_config.dirtMoney, amount, nil, nil) then
        missions[src] = {coords = GetEntityCoords(ped), amount = math.floor(amount - ((amount / 100) * conf.percent))}
        return true
    else
        return false
    end
end)

-- Register Ped Target
---@param netId Net id of the ped
RegisterNetEvent('flex_washing:server:registerPedTarget', function(netId, vehId, coords)
    local src = source
    missions[src].coords = coords
    TriggerClientEvent('flex_washing:client:registerPedTarget', -1, netId, vehId)
end)

-- Register Case Target
---@param netId Net id of the ped
RegisterNetEvent('flex_washing:server:registerSuitcaseTarget', function(netId, npcId, coords)
    local src = source
    missions[src].coords = coords
    TriggerClientEvent('flex_washing:client:registerSuitcaseTarget', -1, netId, npcId)
end)


-- Destroy global target
---@param netId of the target
RegisterNetEvent('flex_washing:server:destroyGlobalTarget', function(netId)
    TriggerClientEvent('flex_washing:client:destroyGlobalTarget', -1, netId)
end)

-- GrabMoney
local function isNearGrabPos(ped)
    for k, v in pairs(missions) do
        if #(GetEntityCoords(ped) - v.coords) < 7 then return true, v.amount, k end
    end
    return false, nil, nil
end

RegisterNetEvent('flex_washing:server:grabMoney', function(id)
    local src = source
    Wait(math.random(100,500))
    local ped = GetPlayerPed(src)
    if not ped then return end
    local state, amount, index = isNearGrabPos(ped)
    if not state or not amount then return end
    if not missions[index] then return end
    local player = GetPlayer(src)
    if not player then return end
    SendWebhook('WASHED MONEY', locale('discord.gotmoney', player?.PlayerData?.charinfo?.firstname..' '..player?.PlayerData?.charinfo?.lastname..' ('..player?.PlayerData?.citizenid..')', amount))
    if AddMoney(src, 'cash', amount, 'Omgeruild geld') then
        -- Config.Notify.server(src, locale('success.money_washed'), 'success', 3000)
        missions[index] = nil
        TriggerClientEvent('flex_washing:client:destroyGlobalTarget', -1, id)
    end
end)

-- Reset mission array for player
RegisterNetEvent('flex_washing:server:reset', function()
    local src = id
    if missions[src] then
        if missions[src].amount then
            Config.Mail.server(src, locale('mail.door.lost_money.sender'), locale('mail.door.lost_money.subject'), locale('mail.door.lost_money.message'))
        end
        missions[src] = nil
    end
end)
