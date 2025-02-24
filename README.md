# LuaLab-WaterFill

A QBCore water bottle system that allows players to fill and drink from water bottles at water dispensers.

## Features
- Two types of water bottles (Regular and Premium)
- Modern UI for water filling
- Animated water dispenser interface
- Water level tracking system
- Usage limit for regular bottles
- Thirst management integration
- Target system integration
- Optimized performance

## Dependencies
- QBCore Framework
- qb-core
- qb-target
- qb-inventory

## Installation

### 1. Add Items to `qb-core/shared/items.lua`  
```lua
['metal_bottle'] = {
name = 'metal_bottle',
label = 'Water Bottle',
weight = 500,
type = 'item',
image = 'metal_bottle.png',
unique = true,
useable = true,
shouldClose = true,
combinable = nil,
description = 'Water bottle (10 uses)'
},
['metal_bottle2'] = {
name = 'metal_bottle2',
label = 'Large Water Bottle',
weight = 750,
type = 'item',
image = 'metal_bottle2.png',
unique = true,
useable = true,
shouldClose = true,
combinable = nil,
description = 'Large water bottle (Unlimited uses)'
}

```

### 2. Add Images
Copy the following images to `qb-inventory/html/images/`:
- metal_bottle.png
- metal_bottle2.png

### 3. Add to qb-inventory/html/js/app.js
Add this to your FormatItemInfo function:
```javascript
if (item.name == "metal_bottle") {
    return `Filled: ${item.info.waterAmount || 0}% | Uses: ${item.info.uses || 0}/10`;
} else if (item.name == "metal_bottle2") {
    return `Filled: ${item.info.waterAmount || 0}%`;
}
```

## Configuration
You can modify the following in `config.lua`:
- Notification messages
- Bottle settings (capacity, uses, drink amount)
- Water dispenser props
- Animation settings
- Prop settings
- UI settings

## Usage
1. Get a water bottle (`/giveitem metal_bottle 1` or `/giveitem metal_bottle2 1`)
2. Find a water dispenser
3. Use qb-target to interact with the dispenser
4. Select your bottle and fill amount
5. Use the bottle from your inventory to drink

## Features Explained
- **Regular Bottle (metal_bottle)**
  - Limited to 10 uses
  - Holds up to 100% water
  - Breaks after all uses

- **Premium Bottle (metal_bottle2)**
  - Unlimited uses
  - Holds up to 100% water
  - Never breaks

## Support
For support, join our Discord: [Discord Link]

## Credits
Created by LuaLab

## License
This project is licensed under the MIT License - see the LICENSE file for details