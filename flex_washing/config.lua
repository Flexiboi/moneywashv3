Config = {}

Config.Debug = false
Config.CoreName = {
    qb = 'qb-core',
    esx = 'es_extended',
    ox = 'ox_core',
    ox_inv = 'ox_inventory',
    qbx = 'qbx_core',
    qb_radial = 'qb-radialmenu',
}

Config.Events = {
    unload = 'QBCore:Client:OnPlayerUnload',
    load = 'QBCore:Client:OnPlayerLoaded',
}

Config.Notify = {
    client = function(msg, type, time)
        lib.notify({
            title = msg,
            type = type,
            time = time or 5000,
        })
    end,
    server = function(src, msg, type, time)
        lib.notify(src, {
            title = msg,
            type = type,
            time = time or 5000,
        })
    end,
}

Config.Mail = {
    client = function(sender, subject, message)
        TriggerServerEvent('phone:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message
        })
    end,
    server = function(id, sender, subject, message)
        -- TriggerEvent('flex_orders:server:SendYSeriesMail', sender, subject, message, id)
        exports['qs-smartphone-pro']:sendNewMail(id, {
            sender = sender,
            subject = subject,
            message = message
        })
    end,
}

Config.ResetTime = 30 -- Time in minutes you get to do the mission
Config.RandomPedWeapon = {
    "weapon_bat",
    "weapon_hammer",
    "weapon_golfclub",
    "weapon_bottle",
    "weapon_crowbar",
    "weapon_flashlight",
    "weapon_hatchet",
    "weapon_knife",
    "weapon_machete",
    "weapon_switchblade",
    "weapon_nightstick",
    "weapon_wrench",
    "weapon_battleaxe",
    "weapon_poolcue",
    -- "weapon_snspistol",
}

Config.settings = {
    KnockTime = 8, -- Time in minutes when the person dissappears after knocking
    ScamChance = math.random(20, 30), -- 30 / 100 chance to get scammed
}