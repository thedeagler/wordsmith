class_name DialogData
extends Resource

## Resource for storing dialog information
## Contains an array of dialog strings and current position

@export var dialog_texts: PackedStringArray = []
@export var current_index: int = 0
# Currently doesn't handle multiple speakers
@export var speaker_name: String = ""

## Get the current dialog text
func get_current_text() -> String:
	if current_index < dialog_texts.size():
		return dialog_texts[current_index]
	return ""

## Check if there are more dialogs
func has_next() -> bool:
	return current_index + 1 < dialog_texts.size()

## Advance to next dialog
func next() -> bool:
	if has_next():
		current_index += 1
		return true
	return false

## Reset to first dialog
func reset():
	current_index = 0

## Get total number of dialogs
func get_total_count() -> int:
	return dialog_texts.size()

## Check if dialog is complete
func is_complete() -> bool:
	return current_index >= dialog_texts.size() - 1
