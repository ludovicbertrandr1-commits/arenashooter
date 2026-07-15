extends Area2D

# 1. DÉCLARATION : C'est ici que tu définis la variable manquante
var damage: int = 10 

# 2. CONFIGURATION
var direction: Vector2 = Vector2.ZERO
@export var speed: float = 300.0

# Note : J'ai supprimé 'projectile_scene' d'ici, 
# car un projectile ne doit pas faire apparaître d'autres projectiles.

func _ready():
	# On connecte le signal pour détecter la collision avec le monstre
	body_entered.connect(_on_body_entered)
	
	# Le projectile disparaît tout seul après 3 secondes
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _process(delta):
	# Fait avancer le projectile
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			# Maintenant, le script connaît 'damage' grâce à la ligne 4
			body.take_damage(damage)
			print("DEBUG ATTACK: Dégâts infligés : ", damage)
		queue_free() # Détruit le projectile à l'impact
