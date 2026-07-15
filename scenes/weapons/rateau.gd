extends Area2D

@export var damage: int = 15
@export var attack_speed: float = 1.0 # Temps entre chaque coup (en secondes)
@export var projectile_scene: PackedScene

@onready var animation = $AnimationPlayer
@onready var timer = $CooldownTimer

func _ready():
	# On s'assure que le timer est configuré
	timer.wait_time = attack_speed
	# Connecter le signal de détection
	print("DEBUG PROJECTILE: Je suis né avec ", damage, " de dégâts.")

func _on_body_entered(body):
	# Si c'est un ennemi ET que l'arme est prête (timer arrêté)
	if body.is_in_group("enemies") and timer.is_stopped():
		strike(body)
		
	if body.has_method("take_damage"):
			# Ici, 'damage' a déjà été remplacé par le 15 du joueur via le script de l'arme
			body.take_damage(damage)
			queue_free()

func strike(target):
	# 1. Lancer l'animation
	animation.play("swing")
	
	# 2. Lancer le cooldown pour ne pas taper 60 fois par seconde
	timer.start()
	
	# 3. Infliger les dégâts
	if target.has_method("take_damage"):
		target.take_damage(damage)
		print("Le râteau a frappé pour ", damage, " dégâts !")

func _shoot():
	if not projectile_scene:
		push_error("ERREUR : La scène n'est pas assignée !")
		return
		
	var projectile = projectile_scene.instantiate()
	
	# Récupérer la valeur du joueur
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Transmission de la valeur vers le projectile
		projectile.damage = player.damage
		print("DEBUG WEAPON: J'ai injecté ", projectile.damage, " de dégâts.")
	
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
