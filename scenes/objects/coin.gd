extends Area2D

func _ready() -> void:
	add_to_group("coins")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Collision détectée avec : ", body.name)
	if body.is_in_group("player"):
		GameManager.add_coins(1)
		queue_free()
