extends Control

@onready var slot_label: Label = %slotLabel
@onready var sword: Sprite2D = %sword

var adjective_bubbles: Array[Control] = []

func _ready():
	update_slot_label()
	start_sword_dance()
	create_adjective_bubbles()

func update_slot_label():
	print("update_slot_label")
	var equipped_slot = ""
	
	# Check which slot has the sword equipped
	if PlayerData.noun.feet != null:
		equipped_slot = "feet"
	elif PlayerData.noun.body != null:
		equipped_slot = "body"
	elif PlayerData.noun.hand != null:
		equipped_slot = "hand"
	else:
		equipped_slot = "unknown"
	
	# Update the label text
	slot_label.text = "... " + equipped_slot + " sword"

func start_sword_dance():
	# Create a dancing animation using Tween
	var tween = create_tween()
	tween.set_loops() # Loop forever
	
	# Wiggle left and right
	tween.tween_property(sword, "rotation", -0.3, 0.3)
	tween.tween_property(sword, "rotation", 0.3, 0.3)
	tween.tween_property(sword, "rotation", 0.0, 0.3)
	
	# Add some vertical bobbing
	tween.parallel().tween_property(sword, "position:y", sword.position.y - 10, 0.3)
	tween.parallel().tween_property(sword, "position:y", sword.position.y + 10, 0.3)
	tween.parallel().tween_property(sword, "position:y", sword.position.y, 0.3)
	
	# Add some scaling for extra dance effect
	tween.parallel().tween_property(sword, "scale", Vector2(1.1, 1.1), 0.3)
	tween.parallel().tween_property(sword, "scale", Vector2(0.9, 0.9), 0.3)
	tween.parallel().tween_property(sword, "scale", Vector2(1.0, 1.0), 0.3)

func create_adjective_bubbles():
	# Get the equipped item to access its adjectives
	var equipped_item = null
	if PlayerData.noun.feet != null:
		equipped_item = PlayerData.noun.feet
	elif PlayerData.noun.body != null:
		equipped_item = PlayerData.noun.body
	elif PlayerData.noun.hand != null:
		equipped_item = PlayerData.noun.hand
	
	print("equipped_item", equipped_item)
	var adjectives = []
	
	# Try to get adjectives from equipped item
	if equipped_item and equipped_item.has_method("get_adjectives"):
		adjectives = equipped_item.adjectives
	
	# If no adjectives found, get 3 random ones
	if adjectives.size() == 0:
		Utils.load_adjectives()
		for i in 3:
			adjectives.append(Utils.get_random_adjective())
	
	# Create bubbles for each adjective
	for i in range(adjectives.size()):
		var bubble = create_adjective_bubble(adjectives[i], i, adjectives.size())
		add_child(bubble)
		adjective_bubbles.append(bubble)

func create_adjective_bubble(adjective: AdjectiveData, index: int, total_count: int) -> Control:
	# Load and instantiate the EndAdjBubble scene
	var bubble_scene = preload("res://end/EndAdjBubble.tscn")
	var bubble = bubble_scene.instantiate()
	bubble.name = "AdjectiveBubble_" + str(index)
	
	# Position around the sword (distributed on left and right sides)
	var sword_center = sword.position
	var angle_offset = 0.0
	var radius = 160.0
	
	if total_count == 1:
		# Single adjective - position to the right
		angle_offset = 0.0
	elif total_count == 2:
		# Two adjectives - left and right
		angle_offset = PI if index == 0 else 0.0
	else:
		# Multiple adjectives - distribute around
		angle_offset = (PI * 2 * index) / total_count
		# Alternate between left and right sides
		if index % 2 == 0:
			angle_offset = PI + (PI * index) / (total_count / 2.0)
		else:
			angle_offset = (PI * (index - 1)) / (total_count / 2.0)
	
	var bubble_x = sword_center.x + cos(angle_offset) * radius
	var bubble_y = sword_center.y + sin(angle_offset) * radius
	# Adjust positioning: move up and more to the left
	bubble.position = Vector2(bubble_x - 50, bubble_y - 40) # Center the bubble
	
	# Set the adjective data on the bubble (with delay to ensure scene is ready)
	if bubble.has_method("set_adjective"):
		# Use call_deferred to ensure the scene is fully loaded
		bubble.call_deferred("set_adjective", adjective)
	
	# Add floating animation
	animate_bubble(bubble)
	
	return bubble

func animate_bubble(bubble: Control):
	# Create a gentle floating animation
	var tween = create_tween()
	tween.set_loops()
	
	# Float up and down
	var original_y = bubble.position.y
	tween.tween_property(bubble, "position:y", original_y - 5, 1.0)
	tween.tween_property(bubble, "position:y", original_y + 5, 1.0)
	tween.tween_property(bubble, "position:y", original_y, 1.0)
