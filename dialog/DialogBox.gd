class_name DialogBox
extends Control

## Main dialog controller for displaying text conversations
## Handles dialog display, advancement, and hiding

signal dialog_completed
signal dialog_advanced

@onready var dialog_text: RichTextLabel = $TextContainer/DialogText
@onready var continue_button: Button = $TextContainer/ContinueButton
@onready var background: ColorRect = $Background

var current_dialog_data: DialogData
var dialog_visible: bool = false

func _ready():
	# Connect the continue button
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Initially hide the dialog
	hide_dialog()

## Show dialog with given DialogData
func show_dialog(dialog_data: DialogData):
	current_dialog_data = dialog_data
	current_dialog_data.reset()
	_update_display()
	visible = true
	dialog_visible = true

## Hide the dialog box
func hide_dialog():
	visible = false
	dialog_visible = false
	current_dialog_data = null

## Advance to next dialog
func next_dialog():
	if current_dialog_data and current_dialog_data.has_next():
		current_dialog_data.next()
		_update_display()
		dialog_advanced.emit()
	else:
		# Dialog is complete
		dialog_completed.emit()
		hide_dialog()

## Update the display with current dialog text
func _update_display():
	if current_dialog_data:
		var text = current_dialog_data.get_current_text()
		if current_dialog_data.speaker_name != "":
			text = current_dialog_data.speaker_name + ": " + text
		dialog_text.text = text
		
		# Update continue button text
		if current_dialog_data.is_complete():
			continue_button.text = "Close"
		else:
			continue_button.text = "Continue"

## Handle continue button press
func _on_continue_pressed():
	next_dialog()

## Check if dialog is currently visible
func is_dialog_visible() -> bool:
	return dialog_visible
