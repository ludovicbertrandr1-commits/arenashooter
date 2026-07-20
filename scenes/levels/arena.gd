extends Node2D

# 1. On déclare la variable, mais sans @onready puisqu'il n'est pas encore créé
var player

func _ready() -> void:
	print("Arène chargée avec succès.")
	
	if GameManager.selected_character:
		# On crée le joueur en mémoire
		var player_instance = GameManager.selected_character.instantiate()
		
		# On l'ajoute à la scène
		add_child(player_instance)
		
		# MAGIE : On assigne l'instance à notre variable globale 'player'
		player = player_instance 
		
	else:
		print("ERREUR : Aucun personnage sélectionné !")
	
	# La vérification fonctionne maintenant parfaitement
	if not player:
		push_warning("Attention : Le joueur n'a pas pu être créé au lancement !")
	else:
		print("Joueur prêt : ", player.name)
	
	# Initialisation supplémentaire
	start_game()

func start_game() -> void:
	# Tu peux lancer tes timers ou spawners ici si besoin
	print("Début de la partie...")

# Fonction utilitaire pour relancer la scène proprement (utilisée par player.gd ou le manager)
func reload_arena() -> void:
	get_tree().reload_current_scene()

func _on_wave_end(): # Le nom de ta fonction peut varier
	# 1. On cherche le joueur dans le groupe "player"
	var player = get_tree().get_first_node_in_group("player")
	
	# 2. Si on le trouve, on l'appelle pour qu'il se soigne
	if player:
		player.heal_to_max()

# Exemple de gestion de signal si tu veux gérer les morts depuis l'arène
func _on_player_died() -> void:
	print("Game Over détecté. Rechargement...")
	reload_arena()
