extends Node2D
class_name TownNPC

@export var npc_name: String = "Enchanter"
@export var interaction_range: float = 100.0

var player_in_range: bool = false
var is_interacting: bool = false

func _ready():
	# Connect interaction area signals
	$InteractionArea.body_entered.connect(_on_player_entered)
	$InteractionArea.body_exited.connect(_on_player_exited)

func _input(event):
	if event.is_action_pressed("interact") and player_in_range and not is_interacting:
		interact_with_player()

func _on_player_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered interaction range with ", npc_name)

func _on_player_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left interaction range with ", npc_name)

func interact_with_player():
	is_interacting = true
	add_adjective_to_item()
	is_interacting = false

func add_adjective_to_item():
	var random_adjective = get_random_adjective()
	var player_item = get_player_current_item()
	
	if player_item and player_item.has_method("add_adjective"):
		player_item.add_adjective(random_adjective)
		$SpeechBubble.show_text("I've enchanted your item with: " + random_adjective.word)
		print("Added adjective '", random_adjective.word, "' to player's item")
	else:
		$SpeechBubble.show_text("You need an item to enchant!")

func get_random_adjective():
	# Use existing adjective system
	return Utils.get_random_adjective()

func get_player_current_item():
	# Get player's current item (weapon, etc.)
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("get_current_item"):
		return player.get_current_item()
	elif player:
		# Fallback: try to get the melee weapon directly
		return player.get_node_or_null("MeleeWeapon")
	return null
