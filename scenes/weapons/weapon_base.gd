extends Area2D

@export var projectile_scene: PackedScene
@export var damage: int = 10
var enemies_in_range: Array = []

func _ready():
	# 1. Connexion propre des signaux
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

	# 2. Connexion du Timer
	var timer = get_node_or_null("CooldownTimer")
	if timer:
		if not timer.timeout.is_connected(_shoot):
			timer.timeout.connect(_shoot)
	else:
		push_error("ERREUR : Aucun nœud 'CooldownTimer' trouvé !")

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func get_closest_enemy() -> Node2D:
	# On prend TOUS les nœuds de la scène
	var all_nodes = get_tree().root.get_children()
	# Debug ultra-violent : on regarde ce que sont les ennemis
	var all_enemies = get_tree().get_nodes_in_group("enemies") # Ton groupe actuel
	
	# Si c'est toujours vide, listons les groupes de l'ennemi manuellement
	for node in get_tree().get_nodes_in_group("enemies"): # On ne trouvera rien ici
		pass 
	
	# ESSAYE ÇA :
	# Liste tous les groupes présents dans le jeu pour voir si "enemies" existe vraiment
	print("Groupes existants dans la scène : ", get_tree().get_nodes_in_group("enemies"))
	
	# AFFICHE LE CONTENU RÉEL
	print("DEBUG: Recherche d'ennemis... Taille du groupe 'enemies' : ", all_enemies.size())
	
	if all_enemies.size() == 0:
		# Debug supplémentaire : affiche tous les groupes existants sur la scène
		# pour voir comment tes ennemis sont réellement tagués
		var enemies_in_game = get_tree().get_nodes_in_group("enemy") # Test au cas où c'est un singulier
		print("DEBUG: Taille du groupe 'enemy' (singulier) : ", enemies_in_game.size())
		return null
		
	var closest_enemy: Node2D = null
	var shortest_distance: float = 999999.0
	
	for enemy in all_enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy
			
	return closest_enemy

func _shoot():
	var target = get_closest_enemy()

	if target == null:
		return # Personne en vue, on attend le prochain tic

	print("Cible verrouillée : ", target.name)

	# La sécurité anti-oubli :
	if projectile_scene == null:
		push_error("ERREUR CRITIQUE : La 'Projectile Scene' est vide dans l'inspecteur de cette arme !")
		return

	print("=> PAN ! Tir en cours !")
	look_at(target.global_position)
	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = $Marker2D.global_position
	proj.direction = global_position.direction_to(target.global_position)
