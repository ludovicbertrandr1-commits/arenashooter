extends Area2D

@export var weapon_name: String = "Template Corps à corps"
@export var weapon_cost: int = 10
@export var weapon_type: String = "melee"
@export var damage: int = 18
@export var cooldown: float = 1.0

@onready var cooldown_timer = $CooldownTimer

func _ready() -> void:
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func use_weapon() -> void:
	if cooldown_timer and cooldown_timer.is_stopped():
		attack()
		cooldown_timer.start()

func attack() -> void:
	# Implémenter l'animation ou l'effet dans la scène.
	print("Attaque melee : ", weapon_name)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage + GameManager.damage)
		print("Melee : dégâts appliqués ", damage + GameManager.damage)
