extends Area2D
class_name MeleeWeapon

@export var swing_duration: float = 0.2
@export var damage_amount: int = 10
var swinging: bool = false

signal hit(target)

func _ready():
	# Disable collision by default
	monitoring = false
	connect("body_entered", Callable(self, "_on_body_entered"))

func swing():
	if swinging:
		return
	swinging = true
	monitoring = true
	# Automatically stop swing after duration
	await get_tree().create_timer(swing_duration)
	monitoring = false
	swinging = false

func _on_body_entered(body: Node):
	if swinging:
		$Damager.deal_damage(body, damage_amount)
		emit_signal("hit", body)
