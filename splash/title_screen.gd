extends Control

@onready var title_label: Label = %Title
@onready var play_button: Button = %PlayButton

var correct_title: String = "Word Smith"
var animation_timer: Timer
var is_animating: bool = false
var letters_fixed: int = 0

func _ready():
	play_button.pressed.connect(_on_button_pressed)
	start_title_animation()

# switch scenes when the button is pressed
func _on_button_pressed():
	SceneSwitcher.next_scene()

# randomly change the letters of the title, stopping one letter at a time every 120ms
func start_title_animation():
	is_animating = true
	letters_fixed = 0
	
	# Create a timer for the animation
	animation_timer = Timer.new()
	animation_timer.wait_time = 0.05 # Shuffle every 50ms initially
	animation_timer.timeout.connect(_shuffle_letters)
	add_child(animation_timer)
	
	# Start the shuffling phase
	animation_timer.start()
	
	# After 300ms, switch to settling phase
	await get_tree().create_timer(0.3).timeout
	start_settling_phase()

func start_settling_phase():
	if not is_animating:
		return
	
	# Switch to settling mode
	animation_timer.wait_time = 0.12 # Stop one letter every 120ms
	animation_timer.disconnect("timeout", _shuffle_letters)
	animation_timer.timeout.connect(_fix_next_letter)

func _shuffle_letters():
	if not is_animating:
		return
	
	# Create completely random title
	var random_title = ""
	for i in correct_title.length():
		if correct_title[i] == " ":
			random_title += " "
		else:
			# Generate random letter (A-Z)
			var random_char = char(65 + randi() % 26)
			random_title += random_char
	
	title_label.text = random_title

func _fix_next_letter():
	if not is_animating:
		return
	
	letters_fixed += 1
	
	# If all letters are fixed, stop the animation
	if letters_fixed > correct_title.length():
		stop_title_animation()
		return
	
	# Create the current display: fixed letters + random letters
	var current_title = ""
	for i in correct_title.length():
		if i < letters_fixed:
			# This letter is now fixed
			current_title += correct_title[i]
		elif correct_title[i] == " ":
			# Keep spaces as spaces
			current_title += " "
		else:
			# This letter is still random
			var random_char = char(65 + randi() % 26)
			current_title += random_char
	
	title_label.text = current_title

func stop_title_animation():
	is_animating = false
	if animation_timer:
		animation_timer.stop()
		animation_timer.queue_free()
	
	# Ensure the final title is correct
	title_label.text = correct_title
