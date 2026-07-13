extends Area2D

@export var damage: int = 15
@export var attack_speed: float = 1.0 # Temps entre chaque coup (en secondes)

@onready var animation = $AnimationPlayer
@onready var timer = $CooldownTimer

func _ready():
	# On s'assure que le timer est configuré
	timer.wait_time = attack_speed
	# Connecter le signal de détection

func _on_body_entered(body):
	# Si c'est un ennemi ET que l'arme est prête (timer arrêté)
	if body.is_in_group("enemies") and timer.is_stopped():
		strike(body)

func strike(target):
	# 1. Lancer l'animation
	animation.play("swing")
	
	# 2. Lancer le cooldown pour ne pas taper 60 fois par seconde
	timer.start()
	
	# 3. Infliger les dégâts
	if target.has_method("take_damage"):
		target.take_damage(damage)
		print("Le râteau a frappé pour ", damage, " dégâts !")
