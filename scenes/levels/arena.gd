extends Node2D

@export var objective_scene: PackedScene
var player
var objective

func _ready() -> void:
	print("Arène chargée avec succès.")
	if GameManager.current_mode == "envahisseur":
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
	if objective_scene:
		objective = objective_scene.instantiate()
		objective.position = get_viewport_rect().size / 2
		add_child(objective)
		print("Objectif central instancié pour le mode envahisseur.")
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
