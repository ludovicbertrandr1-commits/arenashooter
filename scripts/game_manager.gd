extends Node

var coins: int = 0
var max_health: int = 100
var damage: int = 10
var speed: float = 300.0

# Coûts
var cost_upgrade: int = 10

func add_coins(amount: int):
	coins += amount

func buy_upgrade(type: String) -> bool:
	if coins >= cost_upgrade:
		coins -= cost_upgrade
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
