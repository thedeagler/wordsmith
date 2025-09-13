extends Node2D

@onready var player = $Player
@onready var camera

func _ready():
	# Set up the camera to follow the player
	if camera and player:
		camera.set_target(player)
		# Set some reasonable bounds for the test scene
		camera.set_bounds(Rect2(-2000, -2000, 4000, 4000))
