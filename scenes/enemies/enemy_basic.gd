extends CharacterBody2D

@export var coin_scene: PackedScene
@export var speed: float = 90.0
@export var max_health: int = 20
@export var damage_amount: int = 10
@onready var attack_timer = $AttackTimer

# Référence pour désactiver la collision proprement
@onready var collision_shape = $CollisionShape2D 

var current_health: int
var player: Node2D = null

func _ready() -> void:
	current_health = max_health
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	print("DEBUG: Je suis un ennemi, je m'ajoute au groupe. Nom du nœud : ", name)
	print("DEBUG: Liste de mes groupes : ", get_groups())
	
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(_delta: float) -> void:
	if player:
		# 1. Calculer la distance entre l'ennemi et le joueur
		var distance = global_position.distance_to(player.global_position)
		
		# 2. Si l'ennemi est trop proche (ex: moins de 30 pixels), il s'arrête
		if distance > 30: 
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
		else:
			# Il est assez près pour attaquer, on annule la vitesse
			velocity = Vector2.ZERO
		
		move_and_slide()

func take_damage(amount: int) -> void:
	# Ajoute ce print pour voir d'où viennent les dégâts
	print("DEBUG : take_damage appelé avec ", amount, " dégâts. (Source probable : ", get_stack()[1].source, ")")
	
	current_health -= amount
	print("Aïe ! Monstre touché. Vie restante : ", current_health)
	
	if current_health <= 0:
		call_deferred("die")

func die() -> void:
	# 1. On désactive la collision avant de supprimer l'objet
	if collision_shape:
		collision_shape.disabled = true
	
	# 2. Faire apparaître la pièce
	if coin_scene:
		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		coin.global_position = global_position
		
	# 3. Supprimer l'ennemi
	queue_free()

func _on_damage_zone_body_entered(body):
	if body.is_in_group("player"):
		# 1. Le joueur attaque l'ennemi
		if "damage" in body:
			take_damage(body.damage)
		
		# 2. L'ennemi attaque le joueur (avec vérification de sécurité)
		if attack_timer: # Vérifie si le nœud existe avant de l'utiliser
			if attack_timer.is_stopped():
				if body.has_method("take_damage"):
					body.take_damage(damage_amount)
					print("L'ennemi a frappé le joueur !")
					attack_timer.start()
		else:
			# Ceci s'affichera une seule fois si le nœud n'est pas trouvé
			push_warning("Le nœud 'AttackTimer' est manquant dans la scène EnemyBasic !")
			

# Quand le joueur entre dans la zone de portée
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		# 1. Attaque immédiatement une première fois
		attack_player()
		# 2. Démarre le timer pour les attaques suivantes
		attack_timer.start()

# Quand le joueur sort de la zone de portée
func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		# Arrête le timer pour qu'il ne tape plus dans le vide
		attack_timer.stop()

# Ce qui se passe à chaque cycle du timer
func _on_attack_timer_timeout():
	attack_player()


func _on_damage_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func attack_player():
	print("L'ennemi attaque !")
	var player = get_tree().get_first_node_in_group("player")
	
	# On vérifie si le joueur existe ET s'il a la fonction pour recevoir des dégâts
	if player and player.has_method("take_damage"):
		# On appelle la fonction take_damage et on lui donne la valeur des dégâts
		player.take_damage(damage_amount)
