extends CanvasLayer

@export var coin_label: Label
@export var spawner: Node2D
@export var weapon_to_buy: PackedScene
@export var bullet_scene: PackedScene

func _ready():
	visible = false

func open_shop():
	visible = true
	get_tree().paused = true
	update_ui()

func update_ui():
	coin_label.text = "Pièces : " + str(GameManager.coins)

func _on_btn_health_pressed():
	if GameManager.buy_upgrade("health"):
		update_ui()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.max_health = GameManager.max_health
			player.current_health = GameManager.max_health
			print("Vie mise à jour : ", player.max_health)
	else:
		print("Pas assez de pièces !")

func _on_btn_damage_pressed():
	if GameManager.buy_upgrade("damage"):
		update_ui()
		# Plus besoin de chercher le joueur ici !
		print("Dégâts mis à jour dans le GameManager : ", GameManager.damage)
	else:
		print("Pas assez de pièces !")

func _on_btn_speed_pressed():
	if GameManager.buy_upgrade("speed"):
		update_ui()
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.speed = GameManager.speed
			print("Vitesse mise à jour : ", player.speed)
	else:
		print("Pas assez de pièces !")

func _on_btn_resume_pressed():
	visible = false
	get_tree().paused = false
	if spawner:
		spawner.start_next_wave()


func _on_btn_bullet_pressed() -> void:
	print("DEBUG: Bouton Bullet pressé !")
	var cost = 2
	
	# 1. Vérification de l'argent (Directement via le GameManager)
	if GameManager.coins >= cost:
		# 2. Déduction des pièces
		GameManager.coins -= cost
		update_ui() # Rafraîchit le label du nombre de pièces
		
		# 3. Ajout de l'arme
		var player = get_tree().get_first_node_in_group("player") 
		if player and weapon_to_buy:
			player.add_weapon(weapon_to_buy)
			print("Achat réussi : Arme ajoutée !")
	else:
		print("Pas assez de pièces !")
		
	pass # Replace with function body.
