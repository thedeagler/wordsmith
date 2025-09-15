extends Node

var noun: NounData
var adjInventory: Array[AdjectiveData] = []
var nounInventory: Array[NounData] = []

var heldItem: NounData

signal inventory_update(inventory_items)

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
		Input.action_press("inventory")
	emit_signal("inventory_update", nounInventory)



func test_player_data():
	# Utils.load_adjectives()
	PlayerData.noun.word = "kirk"
	# for i in 3:
	# 	PlayerData.adjInventory.append(Utils.get_random_adjective())
