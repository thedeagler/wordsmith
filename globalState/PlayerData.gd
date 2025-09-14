extends Node

var player_name: String
var adjectives: Array[AdjectiveData] = []
var inventory: Array

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	inventory.append(resource)
