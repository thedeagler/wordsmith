extends CharacterBody2D

# Exported variables for easy configuration
@export var movement_speed: float = 800.0
@export var acceleration: float = 1000.0
@export var friction: float = 200.0

func _physics_process(delta):
	handle_movement()
	move_and_slide()

func handle_movement():
	# Get input direction
	var input_direction = Vector2()
	
	if Input.is_action_pressed("move_left"):
		print("move_left")
		input_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		print("move_right")
		input_direction.x += 1
	if Input.is_action_pressed("move_up"):
		print("move_up")
		input_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		print("move_down")
		input_direction.y += 1
	
	# Normalize diagonal movement
	input_direction = input_direction.normalized()
	
	# Apply movement
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * movement_speed, acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
