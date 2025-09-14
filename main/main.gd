extends Node2D
var CONTROLLABLE_CHARACTER_SCENE: String = "res://test/ControllableCharacter2D/TestControllableCharacter2D.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"

func _ready():
	# Initialize game data	
	Utils.load_adjectives()

	SceneSwitcher.first_scene()
