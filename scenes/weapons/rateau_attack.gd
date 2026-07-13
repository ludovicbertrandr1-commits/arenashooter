extends Area2D

# Ces variables sont envoyées par ton arme au moment du tir
var direction: Vector2 = Vector2.ZERO
@export var speed: float = 300.0
@export var damage: int = 10

func _ready():
	# On connecte le signal pour détecter la collision avec le monstre
	body_entered.connect(_on_body_entered)
	
	# Le "projectile" du râteau disparaît tout seul après 0.3 seconde
	# (C'est ce qui donne l'effet de coup de mêlée plutôt que de balle de pistolet)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _process(delta):
	# Fait avancer l'attaque dans la direction de l'ennemi
	position += direction * speed * delta

func _on_body_entered(body):
	print("DEBUG ATTACK: Je viens de toucher le nœud : ", body.name)
	
	if body.is_in_group("enemies"):
		print("DEBUG ATTACK: C'est bien un ennemi, je frappe !")
		if body.has_method("take_damage"):
			body.take_damage(damage)
			print("DEBUG ATTACK: Dégâts infligés !")
		else:
			print("ERREUR : L'ennemi n'a pas de fonction 'take_damage' !")
		queue_free()
