extends Node

var noun: NounData
var inventory: Array

func _ready():
	noun = NounData.new()
	inventory = []

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	inventory.append(resource)
