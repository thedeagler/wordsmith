extends Control

@onready var text_label: RichTextLabel = $TextLabel

func _ready():
	# Debug: Check if font is loaded
	var normal_font = text_label.get_theme_font("normal_font")
	var mono_font = text_label.get_theme_font("mono_font")
	print("Normal font loaded: ", normal_font != null)
	print("Mono font loaded: ", mono_font != null)
	if normal_font:
		print("Normal font resource path: ", normal_font.resource_path)
	if mono_font:
		print("Mono font resource path: ", mono_font.resource_path)
	
	# Try to load font programmatically as fallback
	var font_resource = load("res://assets/Alien Font-Regular.otf")
	if font_resource:
		print("Font loaded programmatically: ", font_resource)
		text_label.add_theme_font_override("normal_font", font_resource)
		text_label.add_theme_font_override("mono_font", font_resource)
	else:
		print("Failed to load font programmatically")

# --- Configurable properties ---
@export var typing_speed: float = 0.05   # seconds per character
@export var default_rarity: String = "common"

# --- Internal state ---
var full_text: String = ""
var formatted_text: String = ""
var current_rarity: String = "common"
var char_index: int = 0
var typing: bool = false

# --- Rarity styles ---
var rarity_styles := {
	"common": {
		"prefix": "[color=black]",
		"suffix": "[/color]"
	},
	"rare": {
		"prefix": "[color=blue]",
		"suffix": "[/color]"
	},
	"epic": {
		"prefix": "[b][color=purple]",
		"suffix": "[/color][/b]"
	},
	"legendary": {
		"prefix": "[b][color=gold]",
		"suffix": "[/color][/b]"
	}
}

# Called to display new text
func show_text(new_text: String, rarity: String = default_rarity) -> void:
	if typing:
		# If already typing, finish current text instantly
		finish_typing()

	var style = rarity_styles.get(rarity, rarity_styles[default_rarity])
	# Store the raw text without formatting for typing animation
	full_text = new_text
	# Store the formatted text for display
	formatted_text = style.prefix + new_text + style.suffix
	# Store current rarity for typing animation
	current_rarity = rarity

	char_index = 0
	text_label.clear()
	typing = true
	_type_next_char()

# Typing loop
func _type_next_char() -> void:
	if not typing:
		return

	if char_index < full_text.length():
		# Clear and rebuild the text with formatting up to current character
		text_label.clear()
		var current_text = full_text.substr(0, char_index + 1)
		var style = rarity_styles.get(current_rarity, rarity_styles[default_rarity])
		text_label.append_text(style.prefix + current_text + style.suffix)
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		_type_next_char()
	else:
		typing = false

# Instantly finish typing animation
func finish_typing() -> void:
	typing = false
	text_label.clear()
	text_label.add_textgs
  (formatted_text)
	char_index = full_text.length()
