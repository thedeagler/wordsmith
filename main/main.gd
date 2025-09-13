extends Node2D
var PLAYER_SCENE: String = "res://Player/TestPlayer.tscn"

func _ready():
	get_tree().change_scene_to_file(PLAYER_SCENE)
