extends Node2D
var PLAYER_SCENE: String = "res://player/TestPlayer.tscn"
var CAMERA_SCENE: String = "res://camera/SmoothFollowCamera.tscn"

func _ready():
	get_tree().change_scene_to_file(CAMERA_SCENE)
