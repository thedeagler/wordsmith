extends Node2D
class_name TownNPC

@export var npc_name: String = "Enchanter"
@export var interaction_range: float = 100.0
@export var dialog_data: DialogData

var player_in_range: bool = false
var is_interacting: bool = false

func _ready():
	_setup_interaction_area()

func _setup_interaction_area():
	# Configure the collision shape based on interaction_range
	var collision_shape = $InteractionArea/CollisionShape2D
	if collision_shape:
		# Create a circle shape with the interaction_range as radius
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = interaction_range
		collision_shape.shape = circle_shape

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
	
	var dialog_to_show = first_time_dialog()
	
	if dialog_to_show and dialog_to_show.dialog_texts.size() > 0:
		print("should pop up dialog")
		print("dialog_texts size: ", dialog_to_show.dialog_texts.size())
		# Create and add dialog box to a CanvasLayer for proper UI rendering
		var dialog_box = preload("res://dialog/DialogBox.tscn").instantiate()
		
		# Create a CanvasLayer for UI elements
		var canvas_layer = CanvasLayer.new()
		canvas_layer.layer = 100 # High layer to ensure it's on top
		get_tree().current_scene.add_child(canvas_layer)
		canvas_layer.add_child(dialog_box)
		
		dialog_box.show_dialog(dialog_to_show)
		# Connect to dialog completion to handle enchantment
		dialog_box.dialog_completed.connect(_on_dialog_completed.bind(dialog_box, canvas_layer), CONNECT_ONE_SHOT)
	else:
		# Fallback to old behavior
		add_adjective_to_item()
		is_interacting = false

func _on_dialog_completed(_dialog_box: DialogBox, canvas_layer: CanvasLayer):
	# Dialog finished, now show noun picker
	show_noun_picker()
	is_interacting = false
	# Clean up the dialog box and canvas layer
	if canvas_layer and is_instance_valid(canvas_layer):
		canvas_layer.queue_free()

func add_adjective_to_item():
	var random_adjective = Utils.get_random_adjective()
	var player_item = get_player_current_item()
	
	if player_item and player_item.has_method("add_adjective"):
		player_item.add_adjective(random_adjective)
		print("Added adjective '", random_adjective.word, "' to player's item")
	else:
		print("You need an item to enchant!")

func get_player_current_item():
	# Get player's current item (weapon, etc.)
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("get_current_item"):
		return player.get_current_item()
	elif player:
		# Fallback: try to get the melee weapon directly
		return player.get_node_or_null("MeleeWeapon")
	return null

func first_time_dialog() -> DialogData:
	print("Player data reading, noun: ", PlayerData.noun.name)
	var builder = DialogDataBuilder.new()
	builder.add_speaker("Wordsmith")
	builder.add_texts([
			"Welcome, %s! I am the Wordsmith." % PlayerData.noun.name.capitalize(),
			"I can make your lame nouns so much cooler with... adjectives!",
			"I see you've collected some on the battle field... Let me see...",
		])

	var adjective_text = ", ".join(PlayerData.adjInventory.map(func(adjective: AdjectiveData):
		var color_hex = "#" + adjective.rarity.color.to_html(false)
		return "[color=%s]%s[/color]" % [color_hex, adjective.word]
	))
	builder.add_text(adjective_text + "... so powerful...")

	return builder.build()

func show_noun_picker():
	var noun_picker = preload("res://nounPicker/NounPicker.tscn").instantiate()
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 101 # Higher than dialog layer
	get_tree().current_scene.add_child(canvas_layer)
	canvas_layer.add_child(noun_picker)
	
	# Start picking with player's collected adjectives
	noun_picker.start_picking(PlayerData.adjInventory)
	
	# Connect to completion signal
	noun_picker.all_adjectives_processed.connect(_on_noun_picking_completed.bind(noun_picker, canvas_layer), CONNECT_ONE_SHOT)

func _on_noun_picking_completed(_noun_picker, canvas_layer: CanvasLayer):
	# Clean up
	if canvas_layer and is_instance_valid(canvas_layer):
		canvas_layer.queue_free()
	
	# Clear the adjective inventory since they've been applied
	PlayerData.adjInventory.clear()
