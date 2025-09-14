extends Node
class_name Damageable

signal damaged(amount, source)
signal died(source)

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health

func take_damage(amount: int, source: Node):
	current_health -= amount
	emit_signal("damaged", amount, source)
	print(self, 'was hit for', amount, 'by', source)
	
	if owner.has_method("on_damaged"):
		owner.on_damaged(amount, source)
	
	if current_health <= 0:
		die(source)

func die(source: Node):
	emit_signal("died", source)
	if owner.has_method("on_died"):
		owner.on_died(source)
