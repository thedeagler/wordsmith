class_name RarityData
extends Resource

@export var name: String
@export var color: Color

func _init(p_name: String = ""):
    name = p_name
    color = colorForRarity(p_name)


func colorForRarity(rarity: String) -> Color:
    match rarity:
        "common":
            return Color.GRAY
        "rare":
            return Color.BLUE
        "epic":
            return Color.PURPLE
        "legendary":
            return Color.GOLD
        _:
            return Color.BLACK