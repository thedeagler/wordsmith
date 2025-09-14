extends Node

var current_scene: int = 0

func first_scene():
	_switch_to_scene(SCENES.SCENE_LIST[current_scene])
	current_scene += 1

func next_scene(afterSeconds: float = 0):
	if current_scene >= SCENES.SCENE_LIST.size():
		return

	if current_scene == 0:
		# get current scene and find its index in the SCENE_LIST. + 1 to go to the next scene
		current_scene = SCENES.SCENE_LIST.find(get_tree().current_scene.name) + 1

	if afterSeconds > 0:
		await get_tree().create_timer(afterSeconds).timeout

	_switch_to_scene(SCENES.SCENE_LIST[current_scene])
	current_scene += 1

func _switch_to_scene(scene_path: String):
	get_tree().change_scene_to_file.call_deferred(scene_path)
