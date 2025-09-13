extends Node2D

# References to the colored nodes
@onready var red_node: Node2D = $RedNode
@onready var green_node: Node2D = $GreenNode
@onready var blue_node: Node2D = $BlueNode
@onready var camera: Camera2D = $SmoothFollowCamera

# Array of nodes to cycle through
var target_nodes: Array[Node2D] = []
var current_target_index: int = 0

# Movement settings for the nodes
var movement_speed: float = 200.0
var movement_radius: float = 300.0

func _ready():
	# Initialize the target nodes array
	target_nodes = [red_node, green_node, blue_node]
	
	# Set up the camera to follow the first node
	if camera and target_nodes.size() > 0:
		camera.set_target(target_nodes[current_target_index])
		camera.set_bounds(Rect2(-800, -600, 1600, 1200))
		camera.show_debug_bounds = true # Show bounds for testing
	
	# Start the first node as the target
	_update_target_highlight()

func _process(delta):
	# Move the nodes in circular patterns
	_move_nodes(delta)
	
	# Check for spacebar input
	if Input.is_action_just_pressed("ui_accept"): # Spacebar
		_cycle_to_next_target()

func _move_nodes(_delta):
	# Only the red node moves in a circular pattern
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# Red node - circular movement
	var red_angle = current_time * 0.5
	red_node.position = Vector2(
		cos(red_angle) * movement_radius * 0.8,
		sin(red_angle) * movement_radius * 0.6
	)
	
	# Green node - static position
	green_node.position = Vector2(200, -150)
	
	# Blue node - static position
	blue_node.position = Vector2(-200, 150)

func _cycle_to_next_target():
	# Move to next target
	current_target_index = (current_target_index + 1) % target_nodes.size()
	
	# Update camera target
	if camera and target_nodes[current_target_index]:
		camera.set_target(target_nodes[current_target_index])
		_update_target_highlight()
		
		print("Camera now following: ", target_nodes[current_target_index].name)

func _update_target_highlight():
	# Reset all nodes to normal scale
	for node in target_nodes:
		if node:
			node.scale = Vector2.ONE
	
	# Highlight the current target
	if target_nodes[current_target_index]:
		target_nodes[current_target_index].scale = Vector2(1.2, 1.2)
