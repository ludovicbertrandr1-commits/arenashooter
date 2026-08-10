extends Area2D

@export var weapon_name: String = "Template Distance"
@export var weapon_cost: int = 12
@export var weapon_type: String = "ranged"
@export var damage: int = 12
@export var cooldown: float = 0.8
@export var projectile_scene: PackedScene

@onready var cooldown_timer = $CooldownTimer

func _ready() -> void:
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown

func use_weapon() -> void:
	if cooldown_timer and cooldown_timer.is_stopped():
		shoot()
		cooldown_timer.start()

func shoot() -> void:
	if not projectile_scene:
		push_error("ERREUR : projectile_scene manquante pour ", weapon_name)
		return
	var target = get_closest_enemy()
	if target == null:
		return
	look_at(target.global_position)
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = $Marker2D.global_position
	projectile.direction = global_position.direction_to(target.global_position)
	if projectile.has_method("set_damage"):
		projectile.set_damage(damage + GameManager.damage)

func get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		return null
	var closest: Node2D = null
	var min_distance := INF
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest = enemy
	return closest
