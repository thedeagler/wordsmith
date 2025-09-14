extends Node2D
class_name InventorySlot

@export var slot_type: String = "weapon" # weapon, armor, boots, or item
@export var equipped_item: Resource = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func set_item(item_resource):
	if item_resource:
		if sprite:
			sprite.texture = item_resource.asset
		if label:
			label.text = item_resource.word
		fit_sprite_to_slot()
	else:
		sprite.texture = null
		label.text = ""

func fit_sprite_to_slot():
	if not sprite or not sprite.texture:
		return
	
	var slot_size = $ColorRect.size
	var tex_size = sprite.texture.get_size()
	
	# Calculate scale factor to fit within slot
	var scale_factor = min(slot_size.x / tex_size.x, slot_size.y / tex_size.y)
	sprite.scale = Vector2.ONE * scale_factor
	sprite.position = slot_size / 2  # center in ColorRect
