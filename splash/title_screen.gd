extends Control

@onready var title_label: Label = %Title
@onready var play_button: Button = %PlayButton

var correct_title: String = "Word Smith"
var animation_timer: Timer
var is_animating: bool = false

func _ready():
	play_button.pressed.connect(_on_button_pressed)
	start_title_animation()

# switch scenes when the button is pressed
func _on_button_pressed():
	SceneSwitcher.next_scene()

# randomly change the letters of the title for 1 second, then at the end, stay on the correct title
func start_title_animation():
	is_animating = true
	
	# Create a timer for the animation
	animation_timer = Timer.new()
	animation_timer.wait_time = 0.05 # Change letters every 50ms
	animation_timer.timeout.connect(_randomize_title)
	add_child(animation_timer)
	
	# Start the animation
	animation_timer.start()
	
	# Stop animation after 1 second
	await get_tree().create_timer(1.0).timeout
	stop_title_animation()

func _randomize_title():
	if not is_animating:
		return
	
	var random_title = ""
	for i in correct_title.length():
		if correct_title[i] == " ":
			random_title += " "
		else:
			# Generate random letter (A-Z)
			var random_char = char(65 + randi() % 26)
			random_title += random_char
	
	title_label.text = random_title

func stop_title_animation():
	is_animating = false
	if animation_timer:
		animation_timer.stop()
		animation_timer.queue_free()
	
	# Set the correct title
	title_label.text = correct_title
