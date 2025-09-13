extends Camera2D

# Exported variables for easy configuration
@export var follow_speed: float = 5.0
@export var target: Node2D = null
@export var bounds_enabled: bool = true
@export var bounds_rect: Rect2 = Rect2(0, 0, 1000, 1000)
@export var dead_zone_size: Vector2 = Vector2(50, 50)
@export var smoothing_enabled: bool = true
@export var show_debug_bounds: bool = false

# Internal variables
var _target_position: Vector2
var _is_target_valid: bool = false

func _ready():
	# Set the camera to be current by default
	make_current()
	
	# Initialize target position if we have a target
	if target:
		set_target(target)

func _process(delta):
	if _is_target_valid and smoothing_enabled:
		_update_camera_position(delta)

func _update_camera_position(delta):
	# Get target's current position
	var target_pos = target.global_position
	
	# Check if target is outside dead zone
	var distance_to_target = global_position.distance_to(target_pos)
	var dead_zone_radius = max(dead_zone_size.x, dead_zone_size.y) * 0.5
	
	if distance_to_target > dead_zone_radius:
		# Calculate desired position
		var desired_position = target_pos
		
		# Apply bounds if enabled
		if bounds_enabled:
			desired_position = _clamp_to_bounds(desired_position)
		
		# Smooth interpolation to desired position
		global_position = global_position.lerp(desired_position, follow_speed * delta)

func _clamp_to_bounds(pos: Vector2) -> Vector2:
	# Get camera viewport size for proper bounds calculation
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom_factor = zoom.x # Assuming uniform zoom
	
	# Calculate half viewport size in world coordinates
	var half_viewport = viewport_size * 0.5 / zoom_factor
	
	# Clamp position to stay within bounds
	var clamped_x = clamp(pos.x,
		bounds_rect.position.x + half_viewport.x,
		bounds_rect.position.x + bounds_rect.size.x - half_viewport.x)
	var clamped_y = clamp(pos.y,
		bounds_rect.position.y + half_viewport.y,
		bounds_rect.position.y + bounds_rect.size.y - half_viewport.y)
	
	return Vector2(clamped_x, clamped_y)

func set_target(node: Node2D):
	"""Set the target for the camera to follow"""
	target = node
	_is_target_valid = (target != null and is_instance_valid(target))
	
	if _is_target_valid:
		_target_position = target.global_position
		# If smoothing is disabled, snap immediately to target
		if not smoothing_enabled:
			global_position = _target_position

func clear_target():
	"""Clear the current target"""
	target = null
	_is_target_valid = false

func set_bounds(rect: Rect2):
	"""Update the camera bounds"""
	bounds_rect = rect

func set_bounds_enabled(bounds_on: bool):
	"""Enable or disable bounds checking"""
	bounds_enabled = bounds_on

func set_follow_speed(speed: float):
	"""Set the follow speed"""
	follow_speed = speed

func set_dead_zone_size(size: Vector2):
	"""Set the dead zone size"""
	dead_zone_size = size

func set_smoothing_enabled(smooth_on: bool):
	"""Enable or disable smooth movement"""
	smoothing_enabled = smooth_on
	# If disabling smoothing and we have a target, snap to it
	if not smooth_on and _is_target_valid:
		global_position = target.global_position

func _draw():
	"""Draw debug bounds if enabled"""
	if show_debug_bounds and bounds_enabled:
		# Convert bounds to local coordinates for drawing
		var local_bounds = bounds_rect
		local_bounds.position -= global_position
		
		# Draw bounds rectangle
		draw_rect(local_bounds, Color.RED, false, 2.0)
		
		# Draw center point
		var center = local_bounds.get_center()
		draw_circle(center, 5.0, Color.RED)

func toggle_debug_bounds():
	"""Toggle debug bounds visualization"""
	show_debug_bounds = !show_debug_bounds
	queue_redraw()

# Signal for when target changes (useful for other systems)
signal target_changed(new_target: Node2D)
signal bounds_updated(new_bounds: Rect2)

func _on_target_changed():
	"""Internal function to emit target changed signal"""
	target_changed.emit(target)

func _on_bounds_updated():
	"""Internal function to emit bounds updated signal"""
	bounds_updated.emit(bounds_rect)
