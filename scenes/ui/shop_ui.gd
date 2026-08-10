extends CanvasLayer

@export var coin_label: Label
@export var spawner: Node2D
@export var weapon_to_buy: PackedScene
@export var weapon_cost: int = 5

func _ready() -> void:
	visible = false

func open_shop() -> void:
	visible = true
	get_tree().paused = true
	update_ui()

func update_ui() -> void:
	if coin_label:
		coin_label.text = "Pièces : " + str(GameManager.coins)

func _on_btn_health_pressed() -> void:
	if GameManager.buy_upgrade("health"):
		update_ui()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.max_health = GameManager.max_health
			player.current_health = GameManager.max_health
			print("Vie mise à jour : ", player.max_health)
	else:
		print("Pas assez de pièces !")

func _on_btn_damage_pressed() -> void:
	if GameManager.buy_upgrade("damage"):
		update_ui()
		print("Dégâts mis à jour dans le GameManager : ", GameManager.damage)
	else:
		print("Pas assez de pièces !")

func _on_btn_speed_pressed() -> void:
	if GameManager.buy_upgrade("speed"):
		update_ui()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.speed = GameManager.speed
			print("Vitesse mise à jour : ", player.speed)
	else:
		print("Pas assez de pièces !")

func _on_btn_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
	if spawner:
		spawner.start_next_wave()

func buy_weapon(weapon_scene: PackedScene, cost: int) -> void:
	if GameManager.spend_coins(cost):
		update_ui()
		var player = get_tree().get_first_node_in_group("player")
		if player and weapon_scene:
			player.add_weapon(weapon_scene)
			print("Achat réussi : Arme ajoutée !")
		else:
			print("Erreur : joueur ou arme manquante.")
	else:
		print("Pas assez de pièces !")

func _on_btn_bullet_pressed() -> void:
	print("DEBUG: Bouton d'achat d'arme pressé !")
	buy_weapon(weapon_to_buy, weapon_cost)
