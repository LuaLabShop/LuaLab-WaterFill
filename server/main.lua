local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('LuaLab-WaterFill:server:getBottles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    
    local bottles = {}
    for slot, item in pairs(Player.PlayerData.items) do
        if Config.Bottles[item.name] then
            if not item.info then item.info = {} end
            if not item.info.waterAmount then item.info.waterAmount = 0 end
            item.slot = slot
            table.insert(bottles, item)
        end
    end
    
    cb(bottles)
end)

-- Su doldurma eventi
RegisterNetEvent('LuaLab-WaterFill:server:fillBottle', function(bottleType, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local bottle = nil
    for slot, item in pairs(Player.PlayerData.items) do
        if item.name == bottleType then
            bottle = item
            bottle.slot = slot
            break
        end
    end
    
    if not bottle then
        TriggerClientEvent('QBCore:Notify', src, Config.Notify.noBottle, "error")
        return
    end
    
    local currentAmount = bottle.info and bottle.info.waterAmount or 0
    local newAmount = currentAmount + amount
    
    if newAmount > 100 then
        TriggerClientEvent('QBCore:Notify', src, Config.Notify.cantFill, "error")
        return
    end
    
    -- Şişenin metadata'sını güncelle
    local info = bottle.info or {}
    info.waterAmount = newAmount
    Player.Functions.RemoveItem(bottle.name, 1, bottle.slot)
    Player.Functions.AddItem(bottle.name, 1, bottle.slot, info)
    
    TriggerClientEvent('QBCore:Notify', src, string.format(Config.Notify.filled, newAmount), "success")
end)

-- Su içme kullanımı
QBCore.Functions.CreateUseableItem("metal_bottle", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not item.info then item.info = {} end
    if not item.info.waterAmount then item.info.waterAmount = 0 end
    if not item.info.uses then item.info.uses = 0 end

    if item.info.waterAmount < Config.Bottles[item.name].drinkAmount then
        TriggerClientEvent('QBCore:Notify', source, Config.Notify.noWater, "error")
        return
    end

    if item.info.uses >= Config.Bottles[item.name].maxUses then
        TriggerClientEvent('QBCore:Notify', source, Config.Notify.maxUses, "error")
        Player.Functions.RemoveItem(item.name, 1, item.slot)
        return
    end
    
    -- Animasyonu başlat
    TriggerClientEvent('LuaLab-WaterFill:client:DrinkWater', source, "metal_bottle")
    Wait(3000) -- Animasyon süresi kadar bekle
    
    -- Şişeyi güncelle
    local info = item.info
    info.waterAmount = info.waterAmount - Config.Bottles[item.name].drinkAmount
    info.uses = info.uses + 1
    Player.Functions.RemoveItem(item.name, 1, item.slot)
    Player.Functions.AddItem(item.name, 1, item.slot, info)
    
    -- Susuzluğu tamamen doldur
    Player.Functions.SetMetaData('thirst', 100)
    TriggerClientEvent('hud:client:UpdateNeeds', source, 100)
    TriggerClientEvent('QBCore:Notify', source, string.format(Config.Notify.drinkWithUses, info.waterAmount, info.uses), "success")
end)

QBCore.Functions.CreateUseableItem("metal_bottle2", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not item.info then item.info = {} end
    if not item.info.waterAmount then item.info.waterAmount = 0 end

    if item.info.waterAmount < Config.Bottles[item.name].drinkAmount then
        TriggerClientEvent('QBCore:Notify', source, Config.Notify.noWater, "error")
        return
    end
    
    -- Animasyonu başlat
    TriggerClientEvent('LuaLab-WaterFill:client:DrinkWater', source, "metal_bottle2")
    Wait(3000) -- Animasyon süresi kadar bekle
    
    -- Şişeyi güncelle
    local info = item.info
    info.waterAmount = info.waterAmount - Config.Bottles[item.name].drinkAmount
    Player.Functions.RemoveItem(item.name, 1, item.slot)
    Player.Functions.AddItem(item.name, 1, item.slot, info)
    
    -- Susuzluğu tamamen doldur
    Player.Functions.SetMetaData('thirst', 100)
    TriggerClientEvent('hud:client:UpdateNeeds', source, 100)
    TriggerClientEvent('QBCore:Notify', source, string.format(Config.Notify.drink, info.waterAmount), "success")
end) 