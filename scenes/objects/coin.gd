extends Area2D

func _ready() -> void:
	# On connecte le signal quand le joueur entre dans la zone
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Collision détectée avec : ", body.name)
	if body.is_in_group("player"):
		Global.total_gold += 1
		GameManager.add_coins(1)
		
		queue_free() # La pièce disparaît
