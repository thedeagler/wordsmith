extends Area2D

func _ready() -> void:
	%Damageable.damaged.connect(on_damaged)
	%Damageable.died.connect(on_died)

func on_damaged(amount, source):
	print("Enemy took damage: %s from %s" % [amount, source])

func on_died(source):
	print("Enemy died to: %s" % source)
	queue_free()
