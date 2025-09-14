extends Area2D
class_name MeleeWeapon

@export var swing_duration: float = 0.3 # fixed speed
@export var swing_angle: float = 90.0 # fixed arc in degrees
@export var damage_amount: int = 10

var swinging: bool = false
@export var adjectives: Array[AdjectiveData] = []

signal hit(target)

func _ready():
	body_entered.connect(_on_body_entered)
	pass
	
func swing(target_position: Vector2):
	if swinging:
		return
	visible = true
	swinging = true
	# Calculate angle from parent to target
	var parent_global = get_parent().global_position
	var direction = (target_position - parent_global).angle()

	# Set start and end rotation relative to parent
	var half_arc = deg_to_rad(swing_angle / 2)
	var start_rot = direction - half_arc
	var end_rot = direction + half_arc

	rotation = start_rot

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.animation_finished.connect(_end_swing)

func _end_swing(anim_name):
	if anim_name == "RESET":
		swinging = false
		visible = false


func _on_body_entered(body: Node2D) -> void:
	$Damager.deal_damage(body, damage_amount)
	emit_signal("hit", body)

func _on_area_entered(area: Area2D) -> void:
	$Damager.deal_damage(area, damage_amount)
	emit_signal("hit", area) # Replace with function body.

func add_adjective(adjective: AdjectiveData):
	adjectives.append(adjective)
	print("Added adjective '", adjective.word, "' to weapon. Total adjectives: ", adjectives.size())
