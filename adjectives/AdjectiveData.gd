class_name AdjectiveData
extends Resource

@export var word: String
@export var rarity: String

func _init(p_word: String = "", p_rarity: String = "common"):
	word = p_word
	rarity = p_rarity
