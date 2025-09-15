extends Node2D

# Main scene controller for character creation
# Handles the name input phase and manages UI transitions

signal name_submitted(name: String)

@onready var name_input_panel = $UI/NameInputPanel
@onready var adjective_container: HBoxContainer = $UI/AdjectiveContainer/HBoxContainer
@onready var character_description_label = %DescriptionLabel

func _ready():
	# Initialize the scene
	_initialize_ui()
	_connect_signals()

func _initialize_ui():
	# Show name input panel initially, hide description label
	name_input_panel.show_panel()
	character_description_label.get_parent().get_parent().hide()
	adjective_container.get_parent().hide()

func _connect_signals():
	# Connect to name input panel signals
	name_input_panel.name_submitted.connect(_on_name_submitted)
	for card in adjective_container.get_children():
		if card is AdjectiveCard:
			card.card_clicked.connect(_on_adjective_card_clicked)

func _show_adjective_choices():
	adjective_container.get_parent().show()

func _on_adjective_card_clicked(adjective_data: AdjectiveData):
	PlayerData.noun.adjectives.append(adjective_data)
	_update_character_description()
	_refresh_adjective_choices()

	if PlayerData.noun.adjectives.size() >= 3:
		adjective_container.get_parent().hide()
		SceneSwitcher.next_scene(2.5)
		return

func _refresh_adjective_choices():
	for card in adjective_container.get_children():
		if card is AdjectiveCard:
			card.set_adjective_data(Utils.get_random_adjective())

func _on_name_submitted(p_name: String):
	# Handle name submission from the input panel
	if _validate_name(p_name):
		var player_name = p_name.strip_edges()
		print("Name submitted: ", player_name)
		PlayerData.noun.word = player_name
		_update_character_description()
		_show_character_description()
		name_input_panel.hide()
		_show_adjective_choices()
	else:
		# Validation failed, let the panel handle the error
		pass

func _validate_name(player_name: String) -> bool:
	# Validate the entered name according to the plan specifications
	var trimmed_name = player_name.strip_edges()
	
	# Check length (1-20 characters as per plan)
	if trimmed_name.length() < 1 or trimmed_name.length() > 20:
		return false
	
	# Check allowed characters: A-Z, a-z, 0-9, space, hyphen, underscore
	var regex = RegEx.new()
	regex.compile("^[A-Za-z0-9\\s\\-_]+$")
	
	return regex.search(trimmed_name) != null

func _update_character_description():
	# Update the character description label with current name
	var flava_text = "Behold..."
	if PlayerData.noun.word != "":
		for i in range(PlayerData.noun.adjectives.size()):
			var adjective = PlayerData.noun.adjectives[i]
			flava_text += " " + _styled_adjective(adjective)
			if i < PlayerData.noun.adjectives.size() - 1:
				flava_text += ","

		flava_text += " " + PlayerData.noun.word.capitalize()

	character_description_label.text = flava_text

func _styled_adjective(adjective: AdjectiveData) -> String:
	return "[color=" + adjective.rarity.color.to_html() + "]" + adjective.word.to_lower() + "[/color]"

func _show_character_description():
	# Show the character description label
	character_description_label.get_parent().get_parent().show()
	
	# Emit signal for future use (when adjective selection is implemented)
	name_submitted.emit(PlayerData.noun.word)
