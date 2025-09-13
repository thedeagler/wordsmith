extends Node2D
var PLAYER_SCENE: String = "res://test/player/TestPlayer.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"

func _ready():
	get_tree().change_scene_to_file.call_deferred(CAMERA_SCENE)
