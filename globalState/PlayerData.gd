extends Node

var player_name: String
var adjectives: Array[AdjectiveData] = []
var inventory: Array

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	inventory.append(resource)

signal inventory_update

func add_to_inventory(item):
	inventory.append(item)
	emit_signal("inventory_update")

func remove_from_inventory(item):
	inventory.erase(item)
	emit_signal("inventory_update")
