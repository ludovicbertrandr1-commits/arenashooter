extends Area2D

@export var weapon_name: String = "Arme"
@export var weapon_cost: int = 5
@export var weapon_type: String = "ranged"
@export var projectile_scene: PackedScene
@export var damage: int = 10
var enemies_in_range: Array = []

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	var timer = get_node_or_null("CooldownTimer")
	if timer:
		if not timer.timeout.is_connected(_shoot):
			timer.timeout.connect(_shoot)
	else:
		push_error("ERREUR : Aucun nœud 'CooldownTimer' trouvé !")

func use_weapon() -> void:
	var timer = get_node_or_null("CooldownTimer")
	if timer and timer.is_stopped():
		_shoot()
		if timer:
			timer.start()
	elif not timer:
		_shoot()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func get_closest_enemy() -> Node2D:
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	if all_enemies.size() == 0:
		return null
	var closest_enemy: Node2D = null
	var shortest_distance: float = INF
	for enemy in all_enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy
	return closest_enemy

func _shoot() -> void:
	var target = get_closest_enemy()
	if target == null:
		return
	if projectile_scene == null:
		push_error("ERREUR CRITIQUE : La 'Projectile Scene' est vide dans l'inspecteur de cette arme !")
		return
	look_at(target.global_position)
	var proj = projectile_scene.instantiate()
	get_tree().current_scene.add_child(proj)
	proj.global_position = $Marker2D.global_position
	proj.direction = global_position.direction_to(target.global_position)
	if proj.has_method("set_damage"):
		proj.set_damage(damage + GameManager.damage)
	
	
