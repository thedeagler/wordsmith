extends Resource
class_name LootData

@export var word: String
@export var partOfSpeech: String = "noun" # "noun" (items) or "adjective" (buffs) or "interjections" (consumables)
@export var rarity: RarityData 
@export var asset: Texture2D
var resource
