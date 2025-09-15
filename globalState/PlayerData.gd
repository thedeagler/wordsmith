extends Node

var player_name: String
var noun: NounData
var adjectives: Array[AdjectiveData] = []
var adjInventory: Array = [AdjectiveData]
var nounInventory: Array = [NounData]
var loadout: Dictionary = {
	"weapon": NounData,
	"armor": NounData,
	"boots": NounData,
}

var heldItem: Resource

func _ready():
	noun = NounData.new()

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	if resource is AdjectiveData:
		adjInventory.append(resource)
	elif resource is NounData:
		nounInventory.append(resource)		
		PlayerData.heldItem = resource
	emit_signal("inventory_update")	


signal inventory_update
