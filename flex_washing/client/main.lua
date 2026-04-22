local targetZones = {}
local globalTargets = {}
local peds = {}
local mission = {
    started = false,
    zone = nil,
    props = {},
    vehicle = nil,
    peds = {},
    targets = {},
    attached = {},
    blips = {},
}

-- Force delete entoty
local function forceDeleteEntity(ent)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return false end
    if IsEntityAttached(ent) then
        DetachEntity(ent, true, true)
        Wait(50)
    end
    FreezeEntityPosition(ent, false)
    SetEntityCollision(ent, true, true)
    SetEntityAsMissionEntity(ent, true, true)
    NetworkRequestControlOfEntity(ent)
    local attempts = 0
    while not NetworkHasControlOfEntity(ent) and attempts < 40 do
        NetworkRequestControlOfEntity(ent)
        Wait(50)
        attempts = attempts + 1
    end
    if NetworkHasControlOfEntity(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DetachEntity(ent, true, true)
        FreezeEntityPosition(ent, false)
        DeleteEntity(ent)
        DeleteObject(ent)
        SetEntityAsNoLongerNeeded(ent)
        return not DoesEntityExist(ent)
    else
        print('^1[flex_washing] Could not gain network control of object.^0')
        return false
    end
end

-- Reset all stuff
local function Reset()
    for k, v in pairs(targetZones) do
        exports.ox_target:removeZone(v)
    end
    for k, v in pairs(mission.targets) do
        exports.ox_target:removeZone(v)
    end
    for k, v in pairs(peds) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    for k, v in pairs(mission.props) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    if DoesEntityExist(mission.vehicle) then
        if DoesEntityExist(mission.vehicle) then
            DeleteEntity(mission.vehicle)
        end
        forceDeleteEntity(mission.vehicle)
    end
    for k, v in pairs(mission.peds) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    for k, v in pairs(mission.blips) do
        if v then
            RemoveBlip(v)
        end
    end
    TriggerServerEvent('flex_washing:server:reset')
end


local function resetMission()
    for k, v in pairs(mission.targets) do
        exports.ox_target:removeZone(v)
    end
    for k, v in pairs(peds) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    for k, v in pairs(mission.props) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    if DoesEntityExist(mission.vehicle) then
        if DoesEntityExist(mission.vehicle) then
            DeleteEntity(mission.vehicle)
        end
        forceDeleteEntity(mission.vehicle)
    end
    for k, v in pairs(mission.peds) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
        forceDeleteEntity(v)
    end
    for k, v in pairs(mission.blips) do
        if v then
            RemoveBlip(v)
        end
    end
    mission = {
        started = false,
        zone = nil,
        props = {},
        vehicle = nil,
        peds = {},
        targets = {},
        attached = {},
        blips = {},
    }
    TriggerServerEvent('flex_washing:server:reset')
end

local function registerModel(model)
    if not IsModelValid(model) then
        print('Invalid ped model: ' .. model)
        return
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
end

local function requstAnim(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(5)
    end
end

-- Find closest object with model name
local function FindClosestObjectModel(model, pos)
    local closestObject = nil
    local closestDistance = -1
    local modelHash = GetHashKey(model)
    local objects = GetGamePool('CObject')

    for i = 1, #objects do
        if GetEntityModel(objects[i]) == modelHash then
            local objectPos = GetEntityCoords(objects[i])
            local distance = #(vector3(pos.x, pos.y, pos.z) - objectPos)

            if closestDistance == -1 or distance < closestDistance then
                closestObject = objects[i]
                closestDistance = distance
            end
        end
    end
    return closestObject
end

-- Take network control of object
local function takeControlOfObject(obj)
    if not DoesEntityExist(obj) then return false end

    SetEntityAsMissionEntity(obj, true, true)
    NetworkRequestControlOfEntity(obj)

    local attempts = 0
    while not NetworkHasControlOfEntity(obj) and attempts < 25 do
        Wait(50)
        NetworkRequestControlOfEntity(obj)
        attempts += 1
    end

    if NetworkHasControlOfEntity(obj) then
        SetEntityAsMissionEntity(obj, true, true)
        return true
    end

    return false
end

-- Delete synced object
local function DeleteSyncedObject(coords, objName)
    local obj = FindClosestObjectModel(objName, coords)
    if not obj or not DoesEntityExist(obj) then return end

    if forceDeleteEntity(obj) then
    else
        print('^1[flex_washing] DeleteSyncedObject fallback failed.^0')
    end
end

-- Make ped hate player
local function MakePedHatePlayer(npc)
    local RandomPedWeapon = math.random(1, #Config.RandomPedWeapon)
    local weaponHash = GetHashKey(Config.RandomPedWeapon[RandomPedWeapon])
    GiveWeaponToPed(npc, weaponHash, 100, false, true)
    SetEntityHealth(npc, 200)
    SetPedArmour(npc, 25)
    SetCanAttackFriendly(npc, false, true)
    TaskCombatPed(npc, cache.ped or PlayerPedId(), 0, 16)
    SetPedCombatAttributes(npc, 46, true)
    SetPedCombatAbility(npc, 100)
    SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
    SetPedAccuracy(npc, math.random(50, 80))
    SetPedFleeAttributes(npc, 0, 0)
    SetPedKeepTask(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityInvincible(npc, false)
end

-- Create Blip
local function CreateBlip(coords, text, icon, color, route)
    mission.blips[#mission.blips + 1] = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(mission.blips[#mission.blips], icon)
    SetBlipDisplay(mission.blips[#mission.blips], 4)
    SetBlipScale(mission.blips[#mission.blips], 0.7)
    SetBlipColour(mission.blips[#mission.blips], color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(mission.blips[#mission.blips])
    if route then
        SetBlipRoute(mission.blips[#mission.blips], true)
        SetBlipRouteColour(mission.blips[#mission.blips], color)
    end
end

local function Load()
    while not LocalPlayer.state['isLoggedIn'] or not LocalPlayer.state.isLoggedIn do
        Wait(1000)
    end
    lib.callback('flex_washing:server:GetDoors', 1000, function(npcs)
        if npcs then
            for k, v in pairs(npcs) do
                targetZones[k] = exports.ox_target:addBoxZone({
                    name = 'flex_washing_door_'..k,
                    coords = v.door.xyz,
                    rotation = v.door.w,
                    size = vec3(1.0, 1.0, 1.0),
                    debug = Config.Debug,
                    options = {
                        {
                            name = 'flex_washing_door_interaction'..k,
                            icon = "fa-solid fa-door-closed",
                            label = locale('target.knock'),
                            distance = 2.0,
                            canInteract = function()
                                local closestPed, closestCoords = lib.getClosestPed(v.ped.coords.xyz, 3)
                                return not (GetEntityModel(closestPed) == GetHashKey(v.ped.model)) and not mission.started
                            end,
                            onSelect = function(args)
                                local ped = cache.ped or PlayerPedId()
                                local pos = GetEntityCoords(ped)
                                if #(pos - v.door.xyz) > 15 then return end
                                local hours = GetClockHours()
                                if hours >= v.time.min and hours <= v.time.max then
                                    TaskTurnPedToFaceCoord(ped, v.ped.coords.xyz)
                                    Wait(500)
                                    requstAnim('timetable@jimmy@doorknock@')
                                    TaskPlayAnim(cache.ped or PlayerPedId(), 'timetable@jimmy@doorknock@', 'knockdoor_idle', 5.0, 5.0, -1, 51, 0, false, false, false)
                                    Wait(math.random(3500, 3800))
                                    ClearPedTasks(cache.ped or PlayerPedId())
                                    Wait(math.random(1500, 3000))
                                    if v.ped.model then
                                        local closestPed, closestCoords = lib.getClosestPed(v.ped.coords.xyz, 3)
                                        if not closestPed or (GetEntityModel(closestPed) ~= GetHashKey(v.ped.model)) then
                                            registerModel(v.ped.model)
                                            peds[k] = CreatePed(4, v.ped.model, vec3(v.ped.coords.x, v.ped.coords.y, v.ped.coords.z-1), v.ped.coords.w, true, true)
                                            FreezeEntityPosition(peds[k], true)
                                            SetEntityInvincible(peds[k], true)
                                            SetBlockingOfNonTemporaryEvents(peds[k], true)
                                            if math.random(0,100) <= 50 then
                                                PlayAmbientSpeech1(peds[k], 'GENERIC_SHOCKED_HIGH', 'SPEECH_PARAMS_STANDARD')
                                            elseif math.random(0,100) <= 50 then
                                                PlayAmbientSpeech1(peds[k], 'GENERIC_INSULT_HIGH', 'SPEECH_PARAMS_STANDARD')
                                            elseif math.random(0,100) <= 50 then
                                                PlayAmbientSpeech1(peds[k], 'HOWS_IT_GOING_GENERIC', 'SPEECH_PARAMS_STANDARD')
                                            else
                                                PlayAmbientSpeech1(peds[k], 'GENERIC_FUCK_OFF', 'SPEECH_PARAMS_STANDARD')
                                            end
                                            Wait(60*1000*Config.settings.KnockTime)
                                            DeleteEntity(peds[k])
                                        end
                                    end
                                else
                                    Config.Notify.client(locale('info.not_at_this_time'), 'info', 3000)
                                end
                            end,
                        },
                        {
                            name = 'flex_washing_door_interaction'..k,
                            icon = "fa-brands fa-kakao-talk",
                            label = locale('target.talk'),
                            distance = 2.0,
                            canInteract = function()
                                local closestPed, closestCoords = lib.getClosestPed(v.ped.coords.xyz, 3)
                                return (GetEntityModel(closestPed) == GetHashKey(v.ped.model)) and not mission.started
                            end,
                            onSelect = function(args)
                                local ped = cache.ped or PlayerPedId()
                                local pos = GetEntityCoords(ped)
                                if #(pos - v.door.xyz) > 15 then return end
                                if v.ped.model then
                                    local closestPed, closestCoords = lib.getClosestPed(v.ped.coords.xyz, 3)
                                    if closestPed or (GetEntityModel(closestPed) == GetHashKey(v.ped.model)) then
                                        TaskTurnPedToFaceCoord(ped, GetEntityCoords(closestPed))
                                        TaskTurnPedToFaceCoord(closestPed, GetEntityCoords(ped))
                                        Wait(500)
                                        mission.started = true
                                        ClearPedTasks(closestPed)
                                        PlayAmbientSpeech1(closestPed, 'GENERIC_BUY', 'SPEECH_PARAMS_STANDARD')
                                        local input = lib.inputDialog(locale('dialog.enter_washamount.title', v.maxWash), {
                                            {type = 'number', label = locale('dialog.enter_washamount.amount'), icon = 'money', default = 0, min = 0, max = v.maxWash, required = true},
                                        })
                                        if not input then mission.started = false return end
                                        if tonumber(input[1]) > v.maxWash then mission.started = false return Config.Notify.client(locale('error.cant_wash_that_much'), 'error', 3000) end
                                        if not lib.callback.await('flex_washing:server:HasBlackMoney', 1000, 'doors', k, tonumber(input[1])) then mission.started = false return Config.Notify.client(locale('error.not_enough_blackmoney'), 'error', 3000) end
                                        registerModel('prop_poly_bag_money')
                                        mission.props[#mission.props+1] = CreateObject(`prop_poly_bag_money`, pos.x, pos.y, pos.z, true, true, true)
                                        AttachEntityToEntity(mission.props[#mission.props], ped, GetPedBoneIndex(ped, 18905), 0.200000, -0.150000, 0.190000, -286.899261, 132.100006, 141.498962, true, true, false, true, 1, true)
                                        requstAnim('gestures@f@standing@casual')
                                        TaskPlayAnim(ped, 'gestures@f@standing@casual', 'gesture_point', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                        TaskPlayAnim(closestPed, 'gestures@f@standing@casual', 'gesture_point', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                        PlayAmbientSpeech1(closestPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                                        Wait(650)
                                        ClearPedTasks(ped)
                                        ClearPedTasks(closestPed)
                                        if DoesEntityExist(mission.props[#mission.props]) then
                                            DeleteEntity(mission.props[#mission.props])
                                            mission.props[#mission.props] = nil
                                        end
                                        Wait(1500)
                                        TaskStartScenarioInPlace(closestPed, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
                                        Config.Notify.client(locale('info.get_in_contact'), 'info', 3000)
                                        Wait(math.random(2000, 3500))
                                        Config.Mail.client(locale('mail.door.start.sender'), locale('mail.door.start.subject'), locale('mail.door.start.message'))
                                        ClearPedTasks(closestPed)

                                        local deliverPoint = v.dropofflocations[math.random(1, #v.dropofflocations)]
                                        while IsAnyPedNearPoint(deliverPoint.coords.x, deliverPoint.coords.y, deliverPoint.coords.z, 5.0)
                                        or IsAnyVehicleNearPoint(deliverPoint.coords.x, deliverPoint.coords.y, deliverPoint.coords.z, 5.0) do
                                            deliverPoint = v.dropofflocations[math.random(1, #v.dropofflocations)]
                                            Wait(500)
                                        end
                                        CreateBlip(deliverPoint.coords.xyz, locale('blip.pickup_lock'), 408, 17, true)
                                        mission.zone = lib.points.new(deliverPoint.coords.xyz, 45)
                                        function mission.zone:onEnter()
                                            if not mission.vehicle and mission.started then
                                                registerModel(deliverPoint.car)
                                                mission.vehicle = CreateVehicle(deliverPoint.car, deliverPoint.coords.x, deliverPoint.coords.y, deliverPoint.coords.z, deliverPoint.coords.w, true, true)
                                                SetVehicleDoorsLocked(mission.vehicle, 2)
                                                local doors = GetNumberOfVehicleDoors(mission.vehicle)
                                                if DoesEntityExist(mission.vehicle) then
                                                    if doors >= 3 then
                                                        for i = 1, 4 do
                                                            if deliverPoint.peds[i] then
                                                                registerModel(deliverPoint.peds[i])
                                                                mission.peds[#mission.peds+1] = CreatePedInsideVehicle(mission.vehicle, 0, deliverPoint.peds[i], i-2, true, true)
                                                                SetEntityInvincible(mission.peds[#mission.peds], true)
                                                                SetBlockingOfNonTemporaryEvents(mission.peds[#mission.peds], true)
                                                            end
                                                        end
                                                    else
                                                        if #deliverPoint.peds >= 3 then
                                                            for i = 1, 2 do
                                                                if deliverPoint.peds[i] then
                                                                    registerModel(deliverPoint.peds[i])
                                                                    mission.peds[#mission.peds+1] = CreatePedInsideVehicle(mission.vehicle, 0, deliverPoint.peds[i], i-2, true, true)
                                                                    SetEntityInvincible(mission.peds[#mission.peds], true)
                                                                    SetBlockingOfNonTemporaryEvents(mission.peds[#mission.peds], true)
                                                                end
                                                            end
                                                        else
                                                            for i = 1, #deliverPoint.peds do
                                                                if deliverPoint.peds[i] then
                                                                    registerModel(deliverPoint.peds[i])
                                                                    mission.peds[#mission.peds+1] = CreatePedInsideVehicle(mission.vehicle, 0, deliverPoint.peds[i], i-2, true, true)
                                                                    SetEntityInvincible(mission.peds[#mission.peds], true)
                                                                    SetBlockingOfNonTemporaryEvents(mission.peds[#mission.peds], true)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                mission.targets[#mission.targets + 1] = exports.ox_target:addLocalEntity(mission.vehicle, {
                                                    {
                                                        icon = "fa-brands fa-kakao-talk",
                                                        label = locale('target.ask_for_money'),
                                                        canInteract = function()
                                                            return not IsPedInAnyVehicle(cache.ped or PlayerPedId(), false) and GetPedInVehicleSeat(mission.vehicle, -1) ~= (nil or 0)
                                                        end,
                                                        onSelect = function()
                                                            for k, v in pairs(mission.blips) do
                                                                if v then
                                                                    RemoveBlip(v)
                                                                end
                                                            end

                                                            local npc = GetPedInVehicleSeat(mission.vehicle, math.random(1,4)-2)
                                                            ClearPedTasksImmediately(npc)
                                                            SetPedCanBeKnockedOffVehicle(npc, 1)
                                                            SetPedCanRagdoll(npc, true)
                                                            SetPedFleeAttributes(npc, 0, false)
                                                            SetPedCombatAttributes(npc, 0, false)
                                                            SetEntityInvincible(npc, true)
                                                            SetBlockingOfNonTemporaryEvents(npc, true)
                                                            TaskLeaveVehicle(npc, mission.vehicle, 0)

                                                            local timeout = 0
                                                            while IsPedInAnyVehicle(npc, false) and timeout < 5000 do
                                                                Wait(100)
                                                                timeout = timeout + 100
                                                            end

                                                            local case = CreateObject(`prop_security_case_01`, pos.x, pos.y, pos.z, true, true, true)
                                                            mission.props[#mission.props+1] = case
                                                            mission.attached[npc] = case
                                                            AttachEntityToEntity(case, npc, GetPedBoneIndex(npc, 57005), 0.13, 0.0, -0.01, 0.0, 280.0, 90.0, true, true, false, true, 1, true)
                                                            requstAnim('move_weapon@jerrycan@generic')
                                                            TaskPlayAnim(npc, 'move_weapon@jerrycan@generic', 'idle', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                                                            TriggerServerEvent('flex_washing:server:registerPedTarget', NetworkGetNetworkIdFromEntity(npc),  NetworkGetNetworkIdFromEntity(mission.vehicle), GetEntityCoords(npc))
                                                            Config.Notify.client(locale('info.come_take_money'), 'info', 3000)
                                                            exports.ox_target:removeLocalEntity(mission.vehicle)
                                                        end,
                                                        distance = 4.0
                                                    }
                                                })
                                                SetTimeout(1000*60*Config.ResetTime, function()
                                                    resetMission()
                                                end)
                                            end
                                        end
                                        function mission.zone:onExit()
                                            if mission.started then
                                                local pos = GetEntityCoords(mission.vehicle)
                                                local deleteVehicle = false
                                                for k, v in pairs(mission.peds) do
                                                    if #(pos - GetEntityCoords(v)) > 3.0 then
                                                        deleteVehicle = true
                                                    else
                                                        deleteVehicle = false
                                                    end
                                                end
                                                if DoesEntityExist(mission.vehicle) and deleteVehicle then
                                                    DeleteEntity(mission.vehicle)
                                                    mission.vehicle = 'removed'
                                                end
                                            end
                                        end
                                    end
                                end
                            end,
                        },
                    }
                })
            end
        end
    end)
end

-- Register all targets / start points
AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
        Load()
    end
end)

RegisterNetEvent(Config.Events.load, function()
    Reset()
    Load()
end)

-- Drop suitcase
local function dropSuitCase(coords, npc)
    DeleteSyncedObject(coords, `prop_security_case_01`)
    for k, v in pairs(mission.props) do
        if DoesEntityExist(v) then
            if #(GetEntityCoords(cache.ped or PlayerPedId()) or GetEntityCoords(v)) < 25 then
                DeleteEntity(v)
            end
        end
    end
    Wait(100)
    local case = CreateObject(`prop_security_case_01`, coords.x, coords.y, coords.z, true, true, true)
    mission.props[npc] = case
    PlaceObjectOnGroundProperly(case)
    FreezeEntityPosition(case, true)
    TriggerServerEvent('flex_washing:server:registerSuitcaseTarget', NetworkGetNetworkIdFromEntity(case), NetworkGetNetworkIdFromEntity(npc), GetEntityCoords(case))
end

-- Register Collect Money target
RegisterNetEvent('flex_washing:client:registerPedTarget', function(NetId, vehId)
    local npc = NetworkGetEntityFromNetworkId(NetId)
    local veh = NetworkGetEntityFromNetworkId(vehId)
    if not npc or not veh then return end
    if globalTargets[NetId] then return end
    globalTargets[NetId] = exports.ox_target:addLocalEntity(npc, {
        {
            icon = "fa-brands fa-kakao-talk",
            label = locale('target.ask_for_money'),
            canInteract = function()
                return not IsPedInAnyVehicle(cache.ped or PlayerPedId(), false) and not IsEntityDead(npc) and (GetSelectedPedWeapon(npc) == `WEAPON_UNARMED`) and not IsPedFleeing(npc)
            end,
            onSelect = function()
                -- if not globalTargets[NetId] then return end
                exports.ox_target:removeLocalEntity(npc)
                TriggerServerEvent('flex_washing:server:destroyGlobalTarget', NetId)
                if math.random(1, 100) <= Config.settings.ScamChance then
                    Config.Notify.client(locale('error.scammed'), 'error', 3000)

                    local driver = GetPedInVehicleSeat(veh, -1)
                    if driver then
                        TaskVehicleDriveWander(
                            driver,
                            veh,
                            80.0,
                            786996
                        )
                    end


                    local doors = GetNumberOfVehicleDoors(veh)
                    for i = 1, doors do
                        local ped = GetPedInVehicleSeat(veh, i -2)
                        -- takeControlOfObject(ped)
                        SetEntityInvincible(ped, false)
                        if i-2 == -1 then
                        else
                            TaskLeaveVehicle(ped, veh, 0)
                            Wait(math.random(30, 450))
                            MakePedHatePlayer(ped)
                        end
                    end

                    local timeout = 0
                    while IsPedInAnyVehicle(npc, false) and timeout < 5000 do
                        Wait(100)
                        timeout = timeout + 100
                    end
                    SetEntityInvincible(npc, false)
                    TaskSmartFleePed(npc, cache.ped or PlayerPedId(), 80.0, -1, true, true)
                    CreateThread(function()
                        while not IsEntityDead(npc) do
                            Wait(1000)
                        end
                        local attachedObj = mission.attached[npc]
                        if attachedObj and DoesEntityExist(attachedObj) then
                            if not forceDeleteEntity(attachedObj) then
                                DeleteSyncedObject(GetEntityCoords(npc), `prop_security_case_01`)
                            else
                                mission.attached[npc] = nil
                            end
                        else
                            DeleteSyncedObject(GetEntityCoords(npc), `prop_security_case_01`)
                        end
                        dropSuitCase(GetEntityCoords(npc), npc)
                    end)
                else
                    local ped = cache.ped or PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    requstAnim('gestures@f@standing@casual')
                    TaskPlayAnim(ped, 'gestures@f@standing@casual', 'gesture_point', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                    TaskPlayAnim(npc, 'gestures@f@standing@casual', 'gesture_point', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                    PlayAmbientSpeech1(npc, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                    Wait(650)
                    if DoesEntityExist(mission.attached[npc]) then
                        DeleteEntity(mission.attached[npc])
                        mission.attached[npc] = nil
                    end
                    for k, v in pairs(mission.props) do
                        if DoesEntityExist(v) then
                            DeleteEntity(v)
                        end
                        forceDeleteEntity(v)
                    end
                    mission.props = {}
                    Wait(100)
                    ClearPedTasks(npc)
                    requstAnim('move_weapon@jerrycan@generic')
                    TaskPlayAnim(ped, 'move_weapon@jerrycan@generic', 'idle', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                    local case = CreateObject(`prop_security_case_01`, pos.x, pos.y, pos.z, true, true, true)
                    mission.props[#mission.props+1] = case
                    mission.attached[npc] = case
                    AttachEntityToEntity(case, ped, GetPedBoneIndex(ped, 57005), 0.13, 0.0, -0.01, 0.0, 280.0, 90.0, true, true, false, true, 1, true)
                    Wait(math.random(1000, 2000))
                    if DoesEntityExist(mission.attached[npc]) then
                        DeleteEntity(mission.attached[npc])
                        mission.attached[npc] = nil
                    end
                    for k, v in pairs(mission.props) do
                        if DoesEntityExist(v) then
                            DeleteEntity(v)
                        end
                        forceDeleteEntity(v)
                    end
                    ClearPedTasks(ped)
                    TriggerServerEvent('flex_washing:server:grabMoney')
                    Config.Notify.client(locale('success.money_washed'), 'success', 3000)
                    Wait(math.random(1000,2000))
                    if AreAnyVehicleSeatsFree(veh) then
                        local doors = GetNumberOfVehicleDoors(veh)
                        for i = 1, doors do
                            if IsVehicleSeatFree(veh, i -2) then
                                TaskWarpPedIntoVehicle(npc, veh, i -2)
                                Wait(100)
                                SetPedIntoVehicle(npc, veh, i -2)
                                Wait(100)
                            end
                        end
                        local driver = GetPedInVehicleSeat(veh, -1)
                        TaskVehicleDriveWander(
                            driver,
                            veh,
                            80.0,          -- Speed (higher = faster)
                            786996         -- Driving style (aggressive)
                        )
                    else
                        SetEntityInvincible(npc, false)
                        TaskSmartFleePed(npc, cache.ped or PlayerPedId(), 80.0, -1, true, true)
                    end
                end
                -- globalTargets[NetId] = nil
            end,
            distance = 2.0
        },
    })
end)

-- Register Collect Money target
RegisterNetEvent('flex_washing:client:registerSuitcaseTarget', function(NetId, NpcId)
    local case = NetworkGetEntityFromNetworkId(NetId)
    local npc = NetworkGetEntityFromNetworkId(NpcId)
    if not case then return end
    if case <= 0 then
        if not mission.props[npc] then
            case = GetClosestObjectOfType(GetEntityCoords(npc), 5.0, `prop_security_case_01`, 0, 0, 0)
        else
            case = mission.props[npc]
        end
    end
    globalTargets[NetId] = exports.ox_target:addLocalEntity(case, {
        {
            icon = "fa-solid fa-hand",
            label = locale('target.grab_money'),
            canInteract = function()
                return not IsPedInAnyVehicle(cache.ped or PlayerPedId(), false)
            end,
            onSelect = function()
                exports.ox_target:removeLocalEntity(case)
                -- if not globalTargets[NetId] then return end
                local ped = cache.ped or PlayerPedId()
                local pos = GetEntityCoords(ped)
                if #(pos - GetEntityCoords(case)) > 8.0 then return end
                requstAnim('pickup_object')
                TaskPlayAnim(cache.ped or PlayerId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 48, 0, false, false, false)
                Wait(300)
                local obj = GetClosestObjectOfType(GetEntityCoords(case), 5.0, `prop_security_case_01`, 0, 0, 0)
                if not forceDeleteEntity(obj) then
                    DeleteSyncedObject(GetEntityCoords(case), `prop_security_case_01`)
                end
                Config.Notify.client(locale('succes.pickedup_money'), 'success', 3000)
                TriggerServerEvent('flex_washing:server:grabMoney', NetId)
                -- globalTargets[NetId] = nil
            end,
            distance = 2.0
        },
    })
end)

-- Destroy Global Target
RegisterNetEvent('flex_washing:client:destroyGlobalTarget', function(Id)
    exports.ox_target:removeZone(globalTargets[Id])
    globalTargets[Id] = nil
end)

-- Player unload event
RegisterNetEvent(Config.Events.unload, function()
    TriggerServerEvent('flex_washing:server:destroyGlobalTarget', NetworkGetNetworkIdFromEntity(mission.vehicle))
    Reset()
end)

-- Resource stop event
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Reset()
    end
end)
