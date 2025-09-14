extends Node2D
class_name	Loot

@export var loot: LootData

func _ready() -> void:
	if loot.asset:
		$Sprite2D.texture = loot.asset
#			
func _on_pick_up(body: Node2D) -> void:
	var floating_text = Label.new()
	floating_text.text = loot.word
	floating_text.global_position = global_position
	floating_text.modulate = Color(1,1,1,1)
	body.get_tree().current_scene.add_child(floating_text)

	var tween = floating_text.create_tween()
	tween.tween_property(floating_text, "modulate:a", 0.0, 1.0)
	tween.tween_property(floating_text, "position:y", floating_text.position.y - 20, 2.0)
	tween.connect("finished", Callable(floating_text, "queue_free"))
	tween.play()
	

func _on_hit_box_body_entered(body: Node2D) -> void:
	PlayerData.loot_item(loot.resource)
	_on_pick_up(body)
	queue_free()
