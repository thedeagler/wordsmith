class_name AdjectiveCard
extends PanelContainer

@export var adjective_data: AdjectiveData: set = set_adjective_data
@onready var name_label: RichTextLabel = %NameLabel
@onready var description_label: RichTextLabel = %DescriptionLabel

func _ready():
	adjective_data = Utils.get_random_adjective()
	update_display()

func set_adjective_data(data: AdjectiveData):
	adjective_data = data
	update_display()

func update_display():
	if adjective_data and name_label and description_label:
		name_label.text = adjective_data.word
		description_label.text = adjective_data.description
		name_label.add_theme_color_override("default_color", adjective_data.rarity.color)

		var style = get_theme_stylebox("panel").duplicate()
		add_theme_stylebox_override("panel", style)
		style.border_color = adjective_data.rarity.color
		style.border_width_left = 8
		style.border_width_right = 8
		style.border_width_top = 8
		style.border_width_bottom = 8
