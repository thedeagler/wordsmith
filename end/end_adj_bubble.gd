extends Control

@onready var label: Label = %Label

func _ready():
	# Check if label exists before applying styles
	if label:
		# Add 3px black border around the text
		label.add_theme_constant_override("outline_size", 10)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
	else:
		print("Warning: %Label not found in EndAdjBubble scene")

func set_adjective(adjective: AdjectiveData):
	if label:
		label.text = adjective.word
		if adjective.rarity and adjective.rarity.has_method("get") and adjective.rarity.get("color"):
			label.add_theme_color_override("font_color", adjective.rarity.color)
		else:
			label.add_theme_color_override("font_color", Color.WHITE)
	else:
		print("Error: Cannot set adjective text - label is null")
