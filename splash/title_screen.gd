extends Control

@onready var title_label: RichTextLabel = %Title
@onready var play_button: Button = %PlayButton

var correct_title: String = "Word Smith"
var animation_timer: Timer
var is_animating: bool = false
var letters_fixed: int = 0
var alien_font: FontFile
var bethellen_font: FontFile
var is_settling_phase: bool = false

func _ready():
	play_button.pressed.connect(_on_button_pressed)
	load_fonts()
	
	# Start with play button invisible
	play_button.modulate.a = 0.0
	
	start_title_animation()

func load_fonts():
	# Load Alien font for shuffling phase
	alien_font = load("res://assets/Alien Font-Regular.otf")
	
	# Load BethEllen font for settled phase
	# Note: You may need to adjust this path based on your actual font file
	bethellen_font = load("res://assets/BethEllen-Regular.ttf")
	
	# If Bethellen font doesn't exist, fall back to default
	if not bethellen_font:
		print("Bethellen font not found, using default font")
		bethellen_font = null

# switch scenes when the button is pressed
func _on_button_pressed():
	SceneSwitcher.next_scene()

# randomly change the letters of the title, stopping one letter at a time every 120ms
func start_title_animation():
	is_animating = true
	letters_fixed = 0
	is_settling_phase = false
	
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
	is_settling_phase = true
	animation_timer.wait_time = 0.18 # Stop one letter every 180ms
	animation_timer.disconnect("timeout", _shuffle_letters)
	animation_timer.timeout.connect(_fix_next_letter)

func _shuffle_letters():
	if not is_animating:
		return
	
	# Create completely random title with Alien font
	var random_title = ""
	for i in correct_title.length():
		if correct_title[i] == " ":
			random_title += " "
		else:
			# Generate random letter (A-Z)
			var random_char = char(65 + randi() % 26)
			random_title += random_char
	
	# Display with Alien font using BBCode
	display_text_with_fonts(random_title)

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
	
	# Display with mixed fonts using BBCode
	display_text_with_fonts(current_title)

func stop_title_animation():
	is_animating = false
	if animation_timer:
		animation_timer.stop()
		animation_timer.queue_free()
	
	# Ensure the final title is correct
	display_text_with_fonts(correct_title)
	
	# Wait 200ms before fading in the play button
	await get_tree().create_timer(0.2).timeout
	var tween = create_tween()
	tween.tween_property(play_button, "modulate:a", 1.0, 0.5)

func display_text_with_fonts(text: String):
	# Create BBCode text with mixed fonts and size
	var bbcode_text = ""
	
	for i in text.length():
		var current_char = text[i]
		if current_char == " ":
			bbcode_text += " "
		elif i < letters_fixed:
			# This letter is fixed, use BethEllen font
			if bethellen_font:
				bbcode_text += "[font=res://assets/BethEllen-Regular.ttf][font_size=69]" + current_char + "[/font_size][/font]"
			else:
				bbcode_text += "[font_size=69]" + current_char + "[/font_size]"
		else:
			# This letter is still random, use Alien font
			if alien_font:
				bbcode_text += "[font=res://assets/Alien Font-Regular.otf][font_size=69]" + current_char + "[/font_size][/font]"
			else:
				bbcode_text += "[font_size=69]" + current_char + "[/font_size]"
	
	title_label.text = bbcode_text
