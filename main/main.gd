extends Node2D
var CONTROLLABLE_CHARACTER_SCENE: String = "res://test/ControllableCharacter2D/TestControllableCharacter2D.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"
var INTRO_SCENE: String = "res://levels/intro/Area1.tscn"

func _ready():
	get_tree().change_scene_to_file.call_deferred(INTRO_SCENE)
