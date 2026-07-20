extends Area2D

# 1. DÉCLARATION : Dégâts de base de cette arme spécifique
@export var base_damage: int = 15

# 2. CONFIGURATION
var direction: Vector2 = Vector2.ZERO
@export var speed: float = 300.0

func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			
			# Dégâts de base du râteau + le bonus stocké dans ton GameManager
			var total_damage = base_damage + GameManager.damage
			
			body.take_damage(total_damage)
			print("DEBUG ATTACK: Dégâts infligés : ", total_damage)
			
		queue_free()
