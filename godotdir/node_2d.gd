extends Node2D
@onready var label: Label = $Button/Label
@onready var button: Button = $Button

var original_text: String = ""

func _ready():
	print("ready")
	# Store the original text
	original_text = label.text
	# Connect button hover signals
	button.mouse_entered.connect(_on_button_mouse_entered)
	button.mouse_exited.connect(_on_button_mouse_exited)

func _input(event: InputEvent):
	# Check if Enter key is pressed
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		# Add "?" to the current text
		label.text += "?"
		print("Enter key pressed - added ?")

func _draw() -> void:
	print("drawing")


func _on_button_mouse_entered() -> void:
	print("button mouse enter")
	label.text = "hover"

func _on_button_mouse_exited() -> void:
	print("button mouse exit")
	label.text = original_text
