extends Node

func _tick_ai(delta: float, enemy: Node2D, _target: Node2D):
	if enemy.target == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			enemy.target = players[0]

	if enemy.target:
		var direction = (enemy.target.global_position - enemy.global_position).normalized()
		enemy.global_position += direction * enemy.move_speed * delta
