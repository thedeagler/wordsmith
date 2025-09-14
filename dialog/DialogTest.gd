extends Control

## Test script to demonstrate dialog box usage

@onready var dialog_box: DialogBox = $DialogBox

func _ready():
	# Create some test dialog data
	var dialog_data = DialogData.new()
	dialog_data.speaker_name = "Test Character"
	dialog_data.dialog_texts = [
		"Hello there!",
		"This is a test of the dialog system.",
		"It's working great!",
		"Click continue to advance through the dialog."
	]
	
	# Show the dialog
	dialog_box.show_dialog(dialog_data)
	
	# Connect to dialog signals
	dialog_box.dialog_completed.connect(_on_dialog_completed)
	dialog_box.dialog_advanced.connect(_on_dialog_advanced)

func _on_dialog_completed():
	print("Dialog completed!")

func _on_dialog_advanced():
	print("Dialog advanced to next text")

func _input(event):
	# Press space to show dialog again for testing
	if event.is_action_pressed("ui_accept"):
		var dialog_data = DialogData.new()
		dialog_data.speaker_name = "Another Character"
		dialog_data.dialog_texts = [
			"Press space to test again!",
			"This dialog system is working perfectly."
		]
		dialog_box.show_dialog(dialog_data)
