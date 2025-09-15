class_name NounData
extends Resource

@export var word: String
@export var is_proper_noun: bool = false
@export var adjectives: Array[AdjectiveData] = []
@export var body: NounData
@export var feet: NounData
@export var hand: NounData

func _init(p_name: String = "", p_is_proper_noun: bool = false):
	word = p_name
	is_proper_noun = p_is_proper_noun
