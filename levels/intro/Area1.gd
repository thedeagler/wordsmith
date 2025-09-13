extends Node2D
class_name Area1

# Player object reference
var player: Node2D = null

# Camera reference for following the player
var camera: Camera2D = null

# Transition trigger area
var transition_trigger: Area2D = null

func _ready():
	print("Area1 ready")
	# Find the player in the scene
	player = get_node("Player")
	
	# Find the camera in the scene
	camera = get_node("SmoothFollowCamera")
	
	# Find the transition trigger
	transition_trigger = get_node("TransitionTrigger")
	
	# Set up camera following
	if camera and player:
		camera.set_target(player)
		# Set camera bounds for Area 1
		camera.set_bounds(Rect2(-100, -100, 1100, 200))
	
	# Connect transition signal
	if transition_trigger:
		transition_trigger.body_entered.connect(_on_transition_trigger_entered)

# Handle transition to Area 2
func _on_transition_trigger_entered(body):
	if body == player:
		# Signal that transition should occur
		# This will be handled by the level manager
		get_tree().call_group("level_manager", "transition_to_area2")
