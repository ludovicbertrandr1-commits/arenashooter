extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO

# On renomme en base_damage pour être cohérent avec tes autres armes
@export var base_damage: int = 10 

func _physics_process(delta):
	# Déplace la balle dans la direction donnée par l'arme
	position += direction * speed * delta

func _on_body_entered(body):
	# Vérifie si l'objet touché fait partie du groupe "enemies"
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			
			# Le calcul magique : Dégâts de la balle + Bonus du shop
			var final_damage = base_damage + GameManager.damage
			
			# On applique les dégâts dynamiques
			body.take_damage(final_damage)
			print("DEBUG BULLET: Dégâts infligés : ", final_damage)
		
		# Détruit la balle après l'impact
		queue_free()
