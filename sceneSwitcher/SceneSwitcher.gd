extends Node

const INTRO_SCENE: String = "res://levels/intro/Area1.tscn"
const CHARACTER_CREATION_SCENE: String = "res://levels/characterCreation/CharacterCreation.tscn"

var current_scene: int = 0

const SCENE_LIST: Array[String] = [
	CHARACTER_CREATION_SCENE,
	INTRO_SCENE
]

func first_scene():
	_switch_to_scene(SCENE_LIST[current_scene])
	current_scene += 1

func next_scene(afterSeconds: float = 0):
	if current_scene >= SCENE_LIST.size():
		return

	if afterSeconds > 0:
		await get_tree().create_timer(afterSeconds).timeout

	_switch_to_scene(SCENE_LIST[current_scene])
	current_scene += 1

func _switch_to_scene(scene_path: String):
	get_tree().change_scene_to_file.call_deferred(scene_path)
