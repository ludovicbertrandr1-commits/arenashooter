extends Node

var coins: int = 0
var max_health: int = 100
var damage: int = 0
var speed: float = 300.0

var current_mode: String = "" # Stockera "classique" ou "envahisseur"
var selected_character: PackedScene = null # La scène du personnage choisi

# Coûts de base pour les upgrades
var cost_upgrade_health: int = 10
var cost_upgrade_damage: int = 10
var cost_upgrade_speed: int = 10

func add_coins(amount: int) -> void:
	coins += amount
	print("GameManager: coins = ", coins)

func can_afford(cost: int) -> bool:
	return coins >= cost

func spend_coins(cost: int) -> bool:
	if cost <= 0:
		return true
	if coins >= cost:
		coins -= cost
		print("GameManager: dépense de ", cost, ", solde = ", coins)
		return true
	return false

func buy_upgrade(type: String) -> bool:
	var cost = 0
	match type:
		"health":
			cost = cost_upgrade_health
		"damage":
			cost = cost_upgrade_damage
		"speed":
			cost = cost_upgrade_speed
		_:
			return false

	if spend_coins(cost):
		match type:
			"health":
				max_health += 20
				print("DEBUG: Santé max passée à : ", max_health)
			"damage":
				damage += 5
				print("DEBUG: Dégâts passés à : ", damage)
			"speed":
				speed += 10
				print("DEBUG: Vitesse passée à : ", speed)
		return true
	return false

func reset_run() -> void:
	coins = 0
	current_mode = ""
	selected_character = null
