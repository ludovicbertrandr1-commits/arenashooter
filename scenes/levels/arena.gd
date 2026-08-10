extends Node2D

const OBJECTIVE_PATH: String = "res://scenes/objects/objective.tscn"
var player
var objective

func _ready() -> void:
	print("Arène chargée avec succès. Mode courant = ", GameManager.current_mode)

	if GameManager.current_mode == "envahisseur":
		print("Arena: mode envahisseur détecté, instanciation de l'objectif...")
		setup_objective()

	if GameManager.selected_character:
		var player_instance = GameManager.selected_character.instantiate()
		add_child(player_instance)
		player = player_instance
	else:
		print("ERREUR : Aucun personnage sélectionné !")

	if not player:
		push_warning("Attention : Le joueur n'a pas pu être créé au lancement !")
	else:
		print("Joueur prêt : ", player.name)

	start_game()

func setup_objective() -> void:
	var scene_res = load(OBJECTIVE_PATH)
	if scene_res:
		objective = scene_res.instantiate()
		objective.position = get_viewport_rect().size / 2
		# mettre l'objectif au-dessus des autres éléments
		if objective.has_method("set_z_index"):
			objective.set_z_index(100)
		else:
			# si c'est un Node2D basique
			objective.z_index = 100 if "z_index" in objective else 0
		add_child(objective)
		# forcer la visibilité du sprite s'il existe
		var sprite = objective.get_node_or_null("Sprite2D")
		if sprite:
			sprite.visible = true
		objective.add_to_group("objective")
		objective.set_process(true)
		print("Objectif central instancié pour le mode envahisseur à : ", objective.position)
	else:
		push_warning("Aucun objectif défini pour le mode envahisseur !")

func start_game() -> void:
	print("Début de la partie...")

func reload_arena() -> void:
	get_tree().reload_current_scene()

func _on_wave_end() -> void:
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node:
		player_node.heal_to_max()

func _on_player_died() -> void:
	print("Game Over détecté. Rechargement...")
	reload_arena()
