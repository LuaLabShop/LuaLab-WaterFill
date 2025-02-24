local QBCore = exports['qb-core']:GetCoreObject()

-- Önbelleğe alınmış animasyonlar
CreateThread(function()
    for _, anim in pairs(Config.Animations) do
        RequestAnimDict(anim.dict)
    end
end)

-- UI Durumu
local isUiOpen = false
local selectedBottle = nil

-- Fonksiyon: Yakındaki sebili kontrol et (optimize edildi)
local function isNearWaterDispenser()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    for _, dispenser in pairs(Config.WaterDispensers) do
        if GetClosestObjectOfType(coords.x, coords.y, coords.z, Config.UI.targetDistance, dispenser, false, false, false) ~= 0 then
            return true
        end
    end
    return false
end

-- Su doldurma fonksiyonu (optimize edildi)
local function fillWaterBottle(bottleType, amount)
    if not isNearWaterDispenser() then
        QBCore.Functions.Notify(Config.Notify.noDispenser, "error")
        return
    end

    local ped = PlayerPedId()
    local fillTime = math.ceil((amount / 100) * 5000)
    
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, 1.0, -1, 48, 0, false, false, false)
    
    QBCore.Functions.Progressbar("fill_bottle", "Filling water... " .. amount .. "%", fillTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(ped)
        TriggerServerEvent('LuaLab-WaterFill:server:fillBottle', bottleType, amount)
    end, function()
        ClearPedTasks(ped)
        QBCore.Functions.Notify(Config.Notify.cancelled, "error")
    end)
end

-- UI'ı aç
local function openWaterUI(bottles)
    if isUiOpen then return end
    isUiOpen = true
    SetNuiFocus(true, true)
    
    local formattedBottles = {}
    for _, bottle in pairs(bottles) do
        if bottle.info and bottle.info.waterAmount < 100 then
            table.insert(formattedBottles, {
                label = bottle.label,
                type = bottle.name,
                slot = bottle.slot,
                currentAmount = bottle.info.waterAmount or 0
            })
        end
    end
    
    SendNUIMessage({
        action = "openWaterUI",
        bottles = formattedBottles
    })
end

-- UI'ı kapat
local function closeWaterUI()
    if not isUiOpen then return end
    isUiOpen = false
    SetNuiFocus(false, false)
    selectedBottle = nil
    
    SendNUIMessage({
        action = "closeWaterUI"
    })
end

-- Eventi
RegisterNetEvent('LuaLab-WaterFill:client:openWaterUI', function()
    if isUiOpen then return end
    
    QBCore.Functions.TriggerCallback('LuaLab-WaterFill:server:getBottles', function(bottles)
        if #bottles > 0 then
            openWaterUI(bottles)
        else
            QBCore.Functions.Notify(Config.Notify.noBottlesInv, "error")
        end
    end)
end)

-- Su içme fonksiyonu (optimize edildi)
local function DrinkWater(bottleType)
    local ped = PlayerPedId()
    local anim = Config.Animations.drink
    local propConfig = Config.Props
    local prop
    
    if bottleType == "metal_bottle2" then
        prop = CreateObject(propConfig.metal_bottle2, 0, 0, 0, true, true, true)
        if not DoesEntityExist(prop) then
            prop = CreateObject(propConfig.metal_bottle, 0, 0, 0, true, true, true)
        end
    else
        prop = CreateObject(propConfig.metal_bottle, 0, 0, 0, true, true, true)
    end
    
    local offset = bottleType == "metal_bottle2" and propConfig.premiumOffset or propConfig.defaultOffset
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, propConfig.boneId),
        offset.x, offset.y, offset.z,
        offset.xRot, offset.yRot, offset.zRot,
        true, true, false, true, 1, true
    )
    
    TaskPlayAnim(ped, anim.dict, anim.anim, 1.0, -1.0, anim.duration, anim.flag, 0, false, false, false)
    Wait(anim.duration)
    
    DeleteObject(prop)
    ClearPedTasks(ped)
end

-- Su içme eventi
RegisterNetEvent('LuaLab-WaterFill:client:DrinkWater', function(bottleType)
    DrinkWater(bottleType)
end)

-- ESC tuşu kontrolü
CreateThread(function()
    while true do
        Wait(0)
        if isUiOpen then
            if IsControlJustReleased(0, 177) then -- ESC tuşu
                closeWaterUI()
            end
        else
            Wait(1000)
        end
    end
end)

-- Target için export
exports['qb-target']:AddTargetModel(Config.WaterDispensers, {
    options = {
        {
            type = "client",
            event = "LuaLab-WaterFill:client:openWaterUI",
            icon = Config.UI.targetIcon,
            label = Config.UI.targetLabel,
            canInteract = function() return not isUiOpen end
        },
    },
    distance = Config.UI.targetDistance
})

-- NUI Callback'leri
RegisterNUICallback('closeUI', function(data, cb)
    closeWaterUI()
    cb({})
end)

RegisterNUICallback('fillBottle', function(data, cb)
    if data.bottleType and data.amount then
        fillWaterBottle(data.bottleType, tonumber(data.amount))
        closeWaterUI()
    end
    cb({})
end) 