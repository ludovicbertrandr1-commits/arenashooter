extends Node2D

# 1. Référence au joueur pour s'assurer qu'il est bien là dès le début
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	print("Arène chargée avec succès.")
	
	# Vérification de sécurité pour le joueur
	if not player:
		push_warning("Attention : Aucun nœud dans le groupe 'player' n'a été trouvé au lancement !")
	
	# Initialisation supplémentaire si nécessaire
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
