extends Node

var noun: NounData
var adjInventory: Array[AdjectiveData] = []
var nounInventory: Array[NounData] = []
var loadout: Dictionary = {
	"weapon": NounData,
	"armor": NounData,
	"boots": NounData,
}

var heldItem: Resource


func _ready():
	noun = NounData.new()
	test_player_data()

func loot_item(resource) -> void:
	print('Player received: ', resource.word)
	if resource is AdjectiveData:
		adjInventory.append(resource)
	elif resource is NounData:
		nounInventory.append(resource)
		PlayerData.heldItem = resource
	emit_signal("inventory_update")

signal inventory_update

func test_player_data():
	Utils.load_adjectives()
	PlayerData.noun.word = "kirk"
	for i in 3:
		PlayerData.adjInventory.append(Utils.get_random_adjective())
