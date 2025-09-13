extends Node2D

# Main scene controller for character creation
# Handles the name input phase and manages UI transitions

signal name_submitted(name: String)

var player_name: String = ""
var current_step: int = 0  # 0 = name input, 1+ = future phases

@onready var name_input_panel = $UI/NameInputPanel
@onready var character_description_label = $UI/CharacterDescriptionLabel/Label

func _ready():
	# Initialize the scene
	_initialize_ui()
	_connect_signals()

func _initialize_ui():
	# Show name input panel initially, hide description label
	name_input_panel.show_panel()
	character_description_label.get_parent().hide()

func _connect_signals():
	# Connect to name input panel signals
	name_input_panel.name_submitted.connect(_on_name_submitted)

func _on_name_submitted(name: String):
	# Handle name submission from the input panel
	if _validate_name(name):
		player_name = name.strip_edges()
		_update_character_description()
		_show_character_description()
	current_step += 1
		print("Name submitted: ", player_name)
	else:
		# Validation failed, let the panel handle the error
		pass

func _validate_name(name: String) -> bool:
	# Validate the entered name according to the plan specifications
	var trimmed_name = name.strip_edges()
	
	# Check length (1-20 characters as per plan)
	if trimmed_name.length() < 1 or trimmed_name.length() > 20:
		return false
	
	# Check allowed characters: A-Z, a-z, 0-9, space, hyphen, underscore
	var regex = RegEx.new()
	regex.compile("^[A-Za-z0-9\\s\\-_]+$")
	
	return regex.search(trimmed_name) != null

func _update_character_description():
	# Update the character description label with current name
	if player_name != "":
		character_description_label.text = "You are... " + player_name
	else:
		character_description_label.text = "You are..."

func _show_character_description():
	# Show the character description label
	character_description_label.get_parent().show()
	
	# Emit signal for future use (when adjective selection is implemented)
	name_submitted.emit(player_name)
