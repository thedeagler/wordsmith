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
	
	# Find the camera attached to the player
	camera = get_node("Player/SmoothFollowCamera")
	
	# Find the transition trigger
	transition_trigger = get_node("TransitionTrigger")
	
	# Set up camera following
	if camera and player:
		# Target the ControllableCharacter2D for proper movement following
		var character = player.get_node("ControllableCharacter2D")
		camera.set_target(character)
		# Set camera bounds to match level boundary (2 screens wide, 1.5 screens tall)
		camera.set_bounds(Rect2(0, 0, 3840, 1620))
		
	# Connect transition signal
	if transition_trigger:
		transition_trigger.body_entered.connect(_on_transition_trigger_entered)

# Handle transition to Area 2
func _on_transition_trigger_entered(body):
	print("Something entered transition area: ", body.name if body else "null")
	# Check if it's the player or the ControllableCharacter2D
	var character = player.get_node("ControllableCharacter2D")
	if body == player or body == character:
		print("Player reached transition area! Transitioning to Area 2...")
		# Signal that transition should occur
		# This will be handled by the level manager
		get_tree().call_group("level_manager", "transition_to_area2")
	else:
		print("Not the player, it was: ", body.name if body else "null")
