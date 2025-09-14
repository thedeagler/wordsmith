extends Node2D

@export var move_speed := 80
@export var collision_damage := 10
var target: Node2D = null

func _ready():
	var dmgeable = $Damageable
	dmgeable.entity = self
	$Damageable.damaged.connect(on_damaged)
	$Damageable.died.connect(on_died)

func _physics_process(delta):
	if $AI.has_method("_tick_ai"):
		$AI._tick_ai(delta, self, target)

func on_damaged(amount, source):
	print("Enemy took damage: %s from %s" % [amount, source])

func on_died(source):
	print("Enemy died to: %s" % source)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		$Damager.deal_damage(body, collision_damage)
