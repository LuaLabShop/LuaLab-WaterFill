Config = {}

-- Notify messages
Config.Notify = {
    noDispenser = "No water dispenser nearby!",
    cancelled = "Action cancelled",
    noBottle = "Bottle not found!",
    cantFill = "The bottle can't hold that much water!",
    filled = "Bottle is %d%% full",
    noWater = "Not enough water in the bottle!",
    maxUses = "This bottle can no longer be used!",
    drinkWithUses = "You drank water. Bottle is %d%% full (%d/10 uses)",
    drink = "You drank water. Bottle is %d%% full",
    noBottlesInv = "You don't have any bottles in your inventory!"
}

-- Bottle settings
Config.Bottles = {
    ['metal_bottle'] = {
        label = 'Water Bottle',
        maxUses = 10,
        drinkAmount = 25, -- Amount of water consumed per drink
        thirstFill = 100, -- How much thirst is restored
    },
    ['metal_bottle2'] = {
        label = 'Large Water Bottle',
        maxUses = -1, -- -1 for unlimited uses
        drinkAmount = 25,
        thirstFill = 100,
    }
}

-- Water dispenser props
Config.WaterDispensers = {
    `prop_watercooler`,
    `prop_watercooler_dark`,
}

-- Animation settings
Config.Animations = {
    fill = {
        dict = 'mp_common',
        anim = 'givetake1_a',
        flag = 48
    },
    drink = {
        dict = 'mp_player_intdrink',
        anim = 'loop_bottle',
        flag = 49,
        duration = 3000
    }
}

-- Prop settings
Config.Props = {
    metal_bottle = `prop_ld_flow_bottle`,
    metal_bottle2 = `bottle_blue`,
    boneId = 18905,
    defaultOffset = {
        x = 0.12,
        y = 0.008,
        z = 0.03,
        xRot = 240.0,
        yRot = -60.0,
        zRot = 0.0
    },
    premiumOffset = {
        x = 0.15,
        y = 0.008,
        z = 0.03,
        xRot = 240.0,
        yRot = -60.0,
        zRot = 0.0
    }
}

-- UI settings
Config.UI = {
    targetIcon = "fas fa-tint",
    targetLabel = "Fill Water",
    targetDistance = 2.0
} 