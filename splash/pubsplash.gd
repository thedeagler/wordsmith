extends Control

# on ready, wait 3 seconds and then switch to the next scene
func _ready():
	await get_tree().create_timer(3.0).timeout
	SceneSwitcher.next_scene()
