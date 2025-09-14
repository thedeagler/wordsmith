extends Node
class_name Damageable

signal damaged(amount, source)
signal died(source)

@export var max_health: int = 50
var current_health: int

func _ready():
	current_health = max_health
	
func take_damage(amount: int, source: Node):
	current_health -= amount
	emit_signal("damaged", amount, source)
	print(current_health, get_parent(), source)
	
	if current_health <= 0:
		die(source)

func die(source: Node):
	emit_signal("died", source)
