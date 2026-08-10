extends Node2D

@export var max_health: int = 250
var current_health: int = 0

func _ready() -> void:
	current_health = max_health
	add_to_group("objective")
	visible = true
	# s'assurer que le sprite est visible
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.visible = true
	print("Objectif prêt avec ", current_health, " PV. Node groups: ", get_groups())

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Objectif touché : ", amount, " PV restants = ", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	print("Objectif détruit ! Fin du mode envahisseur.")
	get_tree().reload_current_scene()
