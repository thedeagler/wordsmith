extends Node2D
var CONTROLLABLE_CHARACTER_SCENE: String = "res://test/ControllableCharacter2D/TestControllableCharacter2D.tscn"
var CAMERA_SCENE: String = "res://test/camera/CameraTestScene.tscn"

func _ready():
	# For now, redirect to character creation scene
	# Later this will check for existing player data
	# Initialize game data	
	Utils.load_adjectives()
	print("Adjectives loaded: ", GameState.adjectives)
	SceneSwitcher.first_scene()
