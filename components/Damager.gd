extends Node
class_name Damager

func deal_damage(target: Node, damage_amount: int):
	if target is Node and target.has_node("Damageable"):
		var damageable: Damageable = target.get_node("Damageable")
		damageable.take_damage(damage_amount, owner)
	if target is Area2D and target.owner.has_node("Damageable"):
		var damageable: Damageable = target.owner.get_node("Damageable")
		damageable.take_damage(damage_amount, target.owner)
