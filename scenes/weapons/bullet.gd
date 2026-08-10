extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
@export var base_damage: int = 10

func _physics_process(delta):
	position += direction * speed * delta

func set_damage(value: int) -> void:
	base_damage = value

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			var final_damage = base_damage + GameManager.damage
			body.take_damage(final_damage)
			print("DEBUG BULLET: Dégâts infligés : ", final_damage)
		queue_free()
