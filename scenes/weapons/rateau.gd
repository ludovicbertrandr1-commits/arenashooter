extends Area2D

@export var weapon_name: String = "Rateau"
@export var weapon_cost: int = 8
@export var weapon_type: String = "melee"
@export var damage: int = 15
@export var attack_speed: float = 1.0
@export var projectile_scene: PackedScene

@onready var animation = $AnimationPlayer
@onready var timer = $CooldownTimer

func _ready() -> void:
	if timer:
		timer.wait_time = attack_speed
	print("DEBUG PROJECTILE: Je suis né avec ", damage, " de dégâts.")

func use_weapon() -> void:
	if timer and timer.is_stopped():
		_shoot()
		timer.start()

func _on_body_entered(body):
	if body.is_in_group("enemies") and timer.is_stopped():
		strike(body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func strike(target):
	animation.play("swing")
	if timer:
		timer.start()
	if target.has_method("take_damage"):
		target.take_damage(damage)
		print("Le râteau a frappé pour ", damage, " dégâts !")

func _shoot() -> void:
	if not projectile_scene:
		push_error("ERREUR : La scène n'est pas assignée !")
		return
	var projectile = projectile_scene.instantiate()
	var player = get_tree().get_first_node_in_group("player")
	if player and projectile.has_method("set_damage"):
		projectile.set_damage(damage + GameManager.damage)
