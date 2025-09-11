extends Node2D

var next_scene: String = "res://godotdir/node_2d.tscn"

func _ready():
	print("Main scene ready - transitioning to next scene in 5 seconds")
	
	# Set up timer for scene transition after 5 seconds
	var timer = Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	timer.timeout.connect(_transition_to_next_scene)
	add_child(timer)
	timer.start()

func _transition_to_next_scene():
	print("Transitioning to: ", next_scene)
	get_tree().change_scene_to_file(next_scene)
