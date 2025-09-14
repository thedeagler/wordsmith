extends Node

var player_name: String
var noun: NounData
var adjectives: Array[AdjectiveData] = []
var adjInventory: Array = [AdjectiveData]
var nounInventory: Array = [NounData]

func _ready():
	noun = NounData.new()
	inventory = []

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	if resource is AdjectiveData:
		adjInventory.append(resource)
	elif resource is NounData:
		nounInventory.append(resource)		
	emit_signal("inventory_update")	

signal inventory_update
