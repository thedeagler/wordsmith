extends Node2D
class_name InventorySlot

@export var slot_type: String = "weapon" # weapon, armor, boots, or item
@export var equipped_item: Resource = null

@onready var sprite: TextureRect = $TextureRect
@onready var label: Label = $Label

func set_item(item_resource):
	equipped_item = item_resource
	if item_resource:
		sprite.texture = item_resource.asset # assuming LootData.asset is Texture2D
		label.text = item_resource.word
	else:
		sprite.texture = null
		label.text = ""
