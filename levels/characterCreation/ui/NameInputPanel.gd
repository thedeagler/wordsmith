extends CenterContainer

# UI panel controller for name input
# Handles input field interactions and validation feedback

signal name_submitted(name: String)

@onready var title_label = $VBoxContainer/Title
@onready var name_input = $VBoxContainer/NameInput
@onready var submit_button = $VBoxContainer/SubmitButton
@onready var error_label = $VBoxContainer/ErrorLabel

func _ready():
	# Initialize the panel
	_initialize_ui()
	_connect_signals()
	_apply_dark_theme()

func _initialize_ui():
	# Set initial state
	error_label.hide()
	submit_button.disabled = true
	
	# Set placeholder text
	name_input.placeholder_text = "..."

func _connect_signals():
	# Connect input field signals
	name_input.text_changed.connect(_on_name_input_text_changed)
	name_input.text_submitted.connect(_on_name_input_text_submitted)
	
	# Connect button signal
	submit_button.pressed.connect(_on_submit_button_pressed)

func _apply_dark_theme():
	# Apply dark theme styling as specified in the plan
	# Title styling
	title_label.add_theme_color_override("font_color", Color(0.91, 0.91, 0.91)) # Light gray #E8E8E8
	
	# Input field styling
	name_input.add_theme_color_override("background_color", Color(0.1, 0.1, 0.1)) # Dark charcoal #1A1A1A
	name_input.add_theme_color_override("font_color", Color(0.91, 0.91, 0.91)) # Light gray #E8E8E8
	name_input.add_theme_color_override("font_placeholder_color", Color(0.5, 0.5, 0.5)) # Dimmed gray
	
	# Button styling
	submit_button.add_theme_color_override("font_color", Color(0.91, 0.91, 0.91)) # Light gray #E8E8E8
	submit_button.add_theme_color_override("background_color", Color(0.42, 0.27, 0.76)) # Muted purple #6B46C1
	
	# Error label styling
	error_label.add_theme_color_override("font_color", Color(0.86, 0.15, 0.15)) # Muted red #DC2626

func _on_name_input_text_changed(new_text: String):
	# Real-time validation and button state management
	var trimmed_text = new_text.strip_edges()
	
	# Enable/disable submit button based on input
	submit_button.disabled = trimmed_text.length() < 1
	
	# Clear any existing errors when user types
	clear_error()

func _on_name_input_text_submitted(new_text: String):
	# Handle Enter key submission
	_submit_name(new_text)

func _on_submit_button_pressed():
	# Handle submit button click
	_submit_name(name_input.text)

func _submit_name(player_name: String):
	# Validate and submit the name
	var trimmed_name = player_name.strip_edges()
	
	if trimmed_name.length() < 1:
		show_error("Please enter a name")
		return
	
	if trimmed_name.length() > 20:
		show_error("Name must be 20 characters or less")
		return
	
	# Check for invalid characters
	var regex = RegEx.new()
	regex.compile("^[A-Za-z0-9\\s\\-_]+$")
	
	if regex.search(trimmed_name) == null:
		show_error("Name can only contain letters, numbers, spaces, hyphens, and underscores")
		return
	
	# Name is valid, emit signal
	name_submitted.emit(trimmed_name)

func show_error(message: String):
	# Display validation error message
	error_label.text = message
	error_label.show()

func clear_error():
	# Hide error message
	error_label.hide()

func show_panel():
	# Make panel visible
	visible = true

func hide_panel():
	# Hide panel
	visible = false
