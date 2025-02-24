function FormatItemInfo(item) {
    if (item.name == "metal_bottle") {
        return `Filled: ${item.info.waterAmount || 0}% | Uses: ${item.info.uses || 0}/10`;
    } else if (item.name == "metal_bottle2") {
        return `Filled: ${item.info.waterAmount || 0}%`;
    }
} 