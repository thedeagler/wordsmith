extends Node2D

@onready var tile = $Tile
var tile_size = 512.0 # 8x bigger than 64
var last_camera_pos = Vector2.ZERO

func _ready():
	# Wait a frame for the camera to be ready
	await get_tree().process_frame
	update_tiles()

func _process(_delta):
	update_tiles()

func update_tiles():
	var camera = get_viewport().get_camera_2d()
	# If no camera, use a default position
	var camera_pos = Vector2.ZERO
	if camera:
		camera_pos = camera.global_position
	
	# Only update if camera moved significantly
	if camera_pos.distance_to(last_camera_pos) < tile_size / 4:
		return
	
	last_camera_pos = camera_pos
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Calculate how many tiles we need to cover the screen plus some buffer
	var tiles_x = int(viewport_size.x / tile_size) + 4
	var tiles_y = int(viewport_size.y / tile_size) + 4
	
	# Calculate the starting position (top-left corner)
	var start_x = int(camera_pos.x / tile_size) - tiles_x / 2
	var start_y = int(camera_pos.y / tile_size) - tiles_y / 2
	
	# Clear existing tiles
	for child in get_children():
		if child != tile:
			child.queue_free()
	
	# Create new tiles
	for x in range(tiles_x):
		for y in range(tiles_y):
			var tile_x = start_x + x
			var tile_y = start_y + y
			
			# Create a new tile
			var new_tile = ColorRect.new()
			new_tile.size = Vector2(tile_size, tile_size)
			new_tile.position = Vector2(tile_x * tile_size, tile_y * tile_size)
			
			# Checkerboard pattern
			if (tile_x + tile_y) % 2 == 0:
				new_tile.color = Color(0.8, 0.8, 0.8, 1) # Light grey
			else:
				new_tile.color = Color(0.9, 0.9, 0.9, 1) # Very light grey
			
			add_child(new_tile)
