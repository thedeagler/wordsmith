extends Control
class_name NounPickerTest

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var status_label: Label = $VBoxContainer/StatusLabel

var noun_picker: NounPicker

func _ready():
	# Load adjectives and create test data
	Utils.load_adjectives()
	setup_test_data()
	
	# Connect button
	start_button.pressed.connect(_on_start_test)

func setup_test_data():
	# Create a test noun with only some equipped items (more realistic)
	PlayerData.noun = NounData.new("TestCharacter")
	PlayerData.noun.body = NounData.new("Sword") # Has body
	PlayerData.noun.feet = null # No feet equipped
	PlayerData.noun.hand = NounData.new("Gloves") # Has hand
	
	# Create some test adjectives
	PlayerData.adjInventory.clear()
	for i in 5:
		var adjective = Utils.get_random_adjective()
		if adjective:
			PlayerData.adjInventory.append(adjective)
	
	print("Test setup complete:")
	print("- Main noun: ", PlayerData.noun.word)
	print("- Body: ", PlayerData.noun.body.word if PlayerData.noun.body else "None")
	print("- Feet: ", PlayerData.noun.feet.word if PlayerData.noun.feet else "None")
	print("- Hand: ", PlayerData.noun.hand.word if PlayerData.noun.hand else "None")
	print("- Adjectives: ", PlayerData.adjInventory.size())

func _on_start_test():
	print("Starting noun picker test...")
	status_label.text = "Testing with " + str(PlayerData.adjInventory.size()) + " adjectives"
	
	# Create and show the noun picker
	noun_picker = preload("res://nounPicker/NounPicker.tscn").instantiate()
	add_child(noun_picker)
	
	# Connect signals
	noun_picker.adjective_applied.connect(_on_adjective_applied)
	noun_picker.all_adjectives_processed.connect(_on_all_adjectives_processed)
	
	# Start picking
	noun_picker.start_picking(PlayerData.adjInventory)

func _on_adjective_applied(adjective: AdjectiveData, target_property: String):
	print("Applied ", adjective.word, " to ", target_property)
	status_label.text = "Applied " + adjective.word + " to " + target_property

func _on_all_adjectives_processed():
	print("All adjectives processed!")
	status_label.text = "Test complete! Check console for results."
	
	# Show final results
	print("\nFinal results:")
	print("- Body adjectives: ", PlayerData.noun.body.adjectives.map(func(adj): return adj.word))
	print("- Feet adjectives: ", PlayerData.noun.feet.adjectives.map(func(adj): return adj.word))
	print("- Hand adjectives: ", PlayerData.noun.hand.adjectives.map(func(adj): return adj.word))
