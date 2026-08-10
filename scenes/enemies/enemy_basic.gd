extends CharacterBody2D

@export var coin_scene: PackedScene
@export var speed: float = 90.0
@export var max_health: int = 20
@export var damage_amount: int = 10
@onready var attack_timer = $AttackTimer
@onready var collision_shape = $CollisionShape2D

var current_health: int

func _ready() -> void:
	current_health = max_health
	add_to_group("enemies")
	print("DEBUG: Je suis un ennemi, je m'ajoute au groupe. Nom du nœud : ", name)
	print("DEBUG: Liste de mes groupes : ", get_groups())
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(_delta: float) -> void:
	var target = get_current_target()
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance > 30:
			var direction = global_position.direction_to(target.global_position)
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()

func get_current_target() -> Node2D:
	# Diagnostic: log current mode and available groups
	# (print ici pour debug runtime)
	#print("Enemy: current_mode=", GameManager.current_mode)
	if GameManager.current_mode == "envahisseur":
		var objective = get_tree().get_first_node_in_group("objective")
		if objective:
			# debug
			print("Enemy: objectif trouvé -> ", objective.name)
			return objective
		else:
			print("Enemy: aucun objectif trouvé, retomber sur le joueur.")
	return get_tree().get_first_node_in_group("player")

func take_damage(amount: int) -> void:
	print("DEBUG : take_damage appelé avec ", amount, " dégâts.")
	current_health -= amount
	print("Aïe ! Monstre touché. Vie restante : ", current_health)
	if current_health <= 0:
		call_deferred("die")

func die() -> void:
	if collision_shape:
		collision_shape.disabled = true
	if coin_scene:
		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		coin.global_position = global_position
	queue_free()

func _on_damage_zone_body_entered(body):
	if body.is_in_group("player"):
		if "damage" in body:
			take_damage(body.damage)
		if attack_timer and attack_timer.is_stopped():
			if body.has_method("take_damage"):
				body.take_damage(damage_amount)
				print("L'ennemi a frappé le joueur !")
				attack_timer.start()
		else:
			push_warning("Le nœud 'AttackTimer' est manquant dans la scène EnemyBasic !")

func _on_attack_area_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("objective"):
		attack_player()
		attack_timer.start()

func _on_attack_area_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("objective"):
		attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	attack_player()

func _on_damage_zone_body_exited(body: Node2D) -> void:
	pass

func attack_player() -> void:
	print("L'ennemi attaque !")
	var target = get_tree().get_first_node_in_group("objective")
	if not target:
		target = get_tree().get_first_node_in_group("player")
	if target and target.has_method("take_damage"):
		target.take_damage(damage_amount)
