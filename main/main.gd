extends Node2D
var CONTROLLABLE_CHARACTER_SCENE: String = "res://test/ControllableCharacter2D/TestControllableCharacter2D.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"
var INTRO_SCENE: String = "res://levels/intro/Area1.tscn"
var CHARACTER_CREATION_SCENE: String = "res://levels/characterCreation/CharacterCreation.tscn"

func _ready():
	# For now, redirect to character creation scene
	# Later this will check for existing player data
	get_tree().change_scene_to_file.call_deferred(CHARACTER_CREATION_SCENE)
