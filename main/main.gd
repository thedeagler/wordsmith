extends Node2D
var CONTROLLABLE_CHARACTER_SCENE: String = "res://test/ControllableCharacter2D/TestControllableCharacter2D.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"

func _ready():
	# get_tree().change_scene_to_file.call_deferred(CONTROLLABLE_CHARACTER_SCENE)
	$SpeechBubble.show_text(Utils.random_symbol_string(14), "legendary")
