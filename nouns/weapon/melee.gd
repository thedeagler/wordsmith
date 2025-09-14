extends Area2D
class_name MeleeWeapon

@export var swing_duration: float = 0.3
@export var swing_angle: float = 90.0
@export var damage_amount: int = 50

@export var melee_data: NounData

var swinging: bool = false

signal hit(target)

func _ready():
	# for mvp purposes, set the melee data using the sword_noun.tres
	melee_data = preload("res://nouns/weapon/sword_noun.tres")
	$AnimationPlayer.animation_finished.connect(_end_swing)
	
func swing(target_position: Vector2):
	if swinging:
		return
	visible = true
	swinging = true
	
	# swings the weapon relative to mouse position
	var parent_global = get_parent().global_position
	var direction = (target_position - parent_global).angle()

	var half_arc = deg_to_rad(swing_angle / 2)
	var start_rot = direction - half_arc

	rotation = start_rot

	$AnimationPlayer.play("RESET")

func _end_swing(anim_name):
	if anim_name == "RESET":
		swinging = false
		visible = false


func _on_body_entered(body: Node2D) -> void:
	$Damager.deal_damage(body, damage_amount)
	emit_signal("hit", body)

func _on_area_entered(area: Area2D) -> void:
	$Damager.deal_damage(area, damage_amount)
	emit_signal("hit", area)

func add_adjective(adjective: AdjectiveData):
	melee_data.adjectives.append(adjective)
	print("Added adjective '", adjective.word, "' to weapon. Total adjectives: ", melee_data.adjectives.size())
