extends CanvasLayer
class_name InventoryUI

@onready var weapon_slot: InventorySlot = $Loadout/Weapon
@onready var armor_slot: InventorySlot = $Loadout/Armor
@onready var boots_slot: InventorySlot = $Loadout/Boots
@onready var grid_container: GridContainer = $InventoryGrid/GridContainer
var slot_scene := preload("res://UI/inventory/InventorySlot.tscn")

func _ready() -> void:
	PlayerData.inventory_update.connect(populate_inventory)
	populate_inventory(PlayerData.nounInventory)

func _process(_delta: float) -> void:
	%feetsword.visible = PlayerData.noun.feet != null
	%bodysword.visible = PlayerData.noun.body != null
	%handsword.visible = PlayerData.noun.hand != null
	
	if not PlayerData.heldItem:
		$Loadout/Weapon/WeaponButton.disabled = true
		$Loadout/Armor/ArmorButton.disabled = true
		$Loadout/Boot/BootButton.disabled = true
	else:
		$Loadout/Weapon/WeaponButton.disabled = false
		$Loadout/Armor/ArmorButton.disabled = false
		$Loadout/Boot/BootButton.disabled = false

func populate_inventory(inventory_items: Array):
	print('pop inv', inventory_items)
	for child in grid_container.get_children():
		child.queue_free()
		
	for item in inventory_items:
		var slot_instance = slot_scene.instantiate()
		slot_instance.set_item(item)
		slot_instance.slot_type = "item"
		grid_container.add_child(slot_instance)

func equip_item(item: Resource, slot_type: String):
	match slot_type:
		"weapon":
			weapon_slot.set_item(item)
		"armor":
			armor_slot.set_item(item)
		"boots":
			boots_slot.set_item(item)

func _on_inventory_slot_selected(slot: InventorySlot):
	if slot.equipped_item:
		equip_item(slot.equipped_item, slot.slot_type)

func _on_weapon_button_pressed() -> void:
	PlayerData.noun.hand = PlayerData.heldItem
	PlayerData.heldItem = null

func _on_armor_button_pressed() -> void:
	PlayerData.noun.body = PlayerData.heldItem
	PlayerData.heldItem = null

func _on_boot_button_pressed() -> void:
	PlayerData.noun.feet = PlayerData.heldItem
	PlayerData.heldItem = null


func _on_button_pressed() -> void:
	visible = false
