extends Node2D

@export var max_health: int = 250
var current_health: int = 0

func _ready() -> void:
	current_health = max_health
	add_to_group("objective")
	print("Objectif prêt avec ", current_health, " PV.")

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Objectif touché : ", amount, " PV restants = ", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	print("Objectif détruit ! Fin du mode envahisseur.")
	get_tree().reload_current_scene()
