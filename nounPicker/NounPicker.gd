extends Control
class_name NounPicker

signal adjective_applied(adjective: AdjectiveData, target_property: String)
signal all_adjectives_processed

var adjectives_to_process: Array[AdjectiveData] = []
var current_adjective_index: int = 0
var current_adjective: AdjectiveData
var selected_property: String = ""
var selected_noun: NounData

func _ready():
	setup_ui()
	hide()

func setup_ui():
	# Connect button signals
	$VBoxContainer/HBoxContainer/BodyButton.pressed.connect(_on_body_selected)
	$VBoxContainer/HBoxContainer/FeetButton.pressed.connect(_on_feet_selected)
	$VBoxContainer/HBoxContainer/HandButton.pressed.connect(_on_hand_selected)
	$VBoxContainer/ConfirmButton.pressed.connect(_on_confirm_selected)

func start_picking(adjectives: Array[AdjectiveData]):
	adjectives_to_process = adjectives.duplicate()
	current_adjective_index = 0
	
	# Check if player has any equipped nouns
	if not has_any_equipped_nouns():
		print("NounPicker: No equipped nouns found, cannot apply adjectives")
		all_adjectives_processed.emit()
		hide()
		return
	
	show()
	process_next_adjective()

func process_next_adjective():
	if current_adjective_index >= adjectives_to_process.size():
		all_adjectives_processed.emit()
		hide()
		return
	
	current_adjective = adjectives_to_process[current_adjective_index]
	selected_property = ""
	selected_noun = null
	update_ui()
	current_adjective_index += 1

func update_ui():
	# Update title with current adjective (with rarity color)
	var rarity_color = current_adjective.rarity.color
	var color_hex = "#" + rarity_color.to_html(false)
	var title = "Which should be made [color=%s]%s[/color]?" % [color_hex, current_adjective.word]
	$VBoxContainer/TitleLabel.text = title
	
	# Show/hide buttons based on what nouns the player has equipped
	$VBoxContainer/HBoxContainer/BodyButton.visible = PlayerData.noun.body != null
	$VBoxContainer/HBoxContainer/FeetButton.visible = PlayerData.noun.feet != null
	$VBoxContainer/HBoxContainer/HandButton.visible = PlayerData.noun.hand != null
	
	# Update button labels with noun names (only for visible buttons)
	if PlayerData.noun.body != null:
		$VBoxContainer/HBoxContainer/BodyButton.text = "Body: %s" % PlayerData.noun.body.name
	if PlayerData.noun.feet != null:
		$VBoxContainer/HBoxContainer/FeetButton.text = "Feet: %s" % PlayerData.noun.feet.name
	if PlayerData.noun.hand != null:
		$VBoxContainer/HBoxContainer/HandButton.text = "Hand: %s" % PlayerData.noun.hand.name
	
	# Hide selection display and confirm button initially
	$VBoxContainer/SelectionDisplay.visible = false
	$VBoxContainer/ConfirmButton.visible = false
	
	# Update progress
	var progress = "Adjective %d of %d" % [current_adjective_index + 1, adjectives_to_process.size()]
	$VBoxContainer/ProgressLabel.text = progress

func _on_body_selected():
	select_property("body")

func _on_feet_selected():
	select_property("feet")

func _on_hand_selected():
	select_property("hand")

func select_property(property: String):
	selected_property = property
	selected_noun = PlayerData.noun.get(property)
	
	if selected_noun:
		# Show the adjective + noun combination with rarity color using BBCode
		var rarity_color = current_adjective.rarity.color
		var color_hex = "#" + rarity_color.to_html(false)
		var combination_text = "[color=%s]%s[/color] %s" % [color_hex, current_adjective.word, selected_noun.name]
		$VBoxContainer/SelectionDisplay.text = combination_text
		
		# Show the selection and confirm button
		$VBoxContainer/SelectionDisplay.visible = true
		$VBoxContainer/ConfirmButton.visible = true

func _on_confirm_selected():
	if selected_property != "" and selected_noun:
		# Apply adjective to the selected noun property
		selected_noun.adjectives.append(current_adjective)
		adjective_applied.emit(current_adjective, selected_property)
	
	# Process next adjective
	process_next_adjective()

func has_any_equipped_nouns() -> bool:
	return PlayerData.noun.body != null or PlayerData.noun.feet != null or PlayerData.noun.hand != null
