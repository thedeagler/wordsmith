extends CharacterBody2D
class_name ControllableCharacter2D
# Exported variables for easy configuration
@export var movement_speed: float = 800.0
@export var acceleration: float = 1000.0
@export var friction: float = 200.0

func _ready() -> void:
	var dmgeable = $Damageable
	#dmgeable.entisty = self

func _physics_process(delta):
	handle_movement()
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		var mouse_pos = get_global_mouse_position()
		$MeleeWeapon.swing(mouse_pos)

func handle_movement():
	# Get input direction
	var input_direction = Vector2()
	
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_pressed("move_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
	
	# Normalize diagonal movement
	input_direction = input_direction.normalized()
	
	# Apply movement
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * movement_speed, acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
		
func on_damaged(amount: int, _source) -> void:
	print('ow', amount)

func get_current_item():
	# Return the current equipped weapon/item
	return $MeleeWeapon
