extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
@export var damage: int = 10

func _physics_process(delta):
	# Déplace la balle dans la direction donnée par l'arme
	position += direction * speed * delta

func _on_body_entered(body):
	# Vérifie si l'objet touché fait partie du groupe "enemies"
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			# On cherche le joueur dans la scène
			var player = get_tree().get_first_node_in_group("player")
			
			# On utilise les dégâts du joueur s'il existe, sinon on garde la valeur par défaut
			var final_damage = player.damage if player else damage
			
			# On applique les dégâts dynamiques
			body.take_damage(final_damage)
		
		# Détruit la balle après l'impact
		queue_free()
