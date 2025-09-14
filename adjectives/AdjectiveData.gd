class_name AdjectiveData
extends Resource

@export var word: String
@export var rarity: RarityData
@export var description: String
@export var asset: Texture2D

func _init(p_word: String = "", p_rarity: String = "common", p_description: String = ""):
	word = p_word
	rarity = RarityData.new(p_rarity)
	description = p_description
