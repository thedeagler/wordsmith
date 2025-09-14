extends Node2D

@export var move_speed := 80
@export var collision_damage := 10
var target: Node2D = null
@onready var damageable: Damageable = %Damageable

func _ready():
	damageable.died.connect(_on_die)

func _physics_process(delta):
	if $AI.has_method("_tick_ai"):
		$AI._tick_ai(delta, self, target)

func _on_die(_source) -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		%Damager.deal_damage(body, collision_damage)
