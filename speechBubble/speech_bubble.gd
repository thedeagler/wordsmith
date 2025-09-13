extends Control

@onready var text_label: RichTextLabel = $TextLabel

func _ready():
	pass
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
		"color": Color.BLACK,
		"bold": false
	},
	"rare": {
		"color": Color.BLUE,
		"bold": false
	},
	"epic": {
		"color": Color.PURPLE,
		"bold": true
	},
	"legendary": {
		"color": Color.GOLD,
		"bold": true
	}
}

# Called to display new text
func show_text(new_text: String, rarity: String = default_rarity) -> void:
	if typing:
		# If already typing, finish current text instantly
		finish_typing()

	# Store the raw text without formatting for typing animation
	full_text = new_text
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
		
		# Apply formatting using push/pop API
		text_label.push_color(style.color)
		if style.bold:
			text_label.push_bold()
		
		text_label.append_text(current_text)
		
		# Pop formatting
		if style.bold:
			text_label.pop()
		text_label.pop()
		
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		_type_next_char()
	else:
		typing = false

# Instantly finish typing animation
func finish_typing() -> void:
	typing = false
	text_label.clear()
	
	var style = rarity_styles.get(current_rarity, rarity_styles[default_rarity])
	
	# Apply formatting using push/pop API
	text_label.push_color(style.color)
	if style.bold:
		text_label.push_bold()
	
	text_label.append_text(full_text)
	
	# Pop formatting
	if style.bold:
		text_label.pop()
	text_label.pop()
	
	char_index = full_text.length()
