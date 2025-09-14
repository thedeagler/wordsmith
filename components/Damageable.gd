extends Node
class_name Damageable

signal damaged(amount, source)
signal died(source)
@export var entity: Node

@export var max_health: int = 50
var current_health: int

func _ready():
	current_health = max_health
	
func take_damage(amount: int, source: Node):
	current_health -= amount
	emit_signal("damaged", amount, source)
	print(current_health, get_parent(), source)
	if entity.has_method("on_damaged"):
		entity.on_damaged(amount, source)
	
	if current_health <= 0:
		die(source)

func die(source: Node):
	emit_signal("died", source)

	if entity.has_method("on_died"):
		entity.on_died(source)
