extends CharacterBody2D

# --- STATISTIQUES ---
@export var max_health: float = 100.0
@export var speed: float = 300.0
@export var damage: int = 10

# --- CONFIGURATION ---
@export var starting_weapons: Array[PackedScene] = []

# --- ÉTAT INTERNE ---
var current_health: float
var owned_weapons: Array[PackedScene] = []
var current_weapon_index: int = 0
var death_menu_shown: bool = false

# --- NŒUDS ---
@onready var health_bar = $HealthBar
@onready var weapon_container = $WeaponsContainer

const DEATH_MENU_SCENE: String = "res://scenes/ui/DeathMenu.tscn"

func _ready() -> void:
	add_to_group("player")
	max_health = GameManager.max_health
	speed = GameManager.speed
	damage = GameManager.damage
	current_health = max_health
	setup_ui()
	print("DEBUG : Nombre d'armes de départ configurées : ", starting_weapons.size())

	for weapon in starting_weapons:
		print("DEBUG : Tentative d'ajout de : ", weapon.resource_path)
		add_weapon(weapon)

func setup_ui() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	move_and_slide()

	if Input.is_action_just_pressed("ui_accept"):
		attack_with_current_weapon()
	if Input.is_action_just_pressed("ui_select"):
		cycle_weapon()

func attack_with_current_weapon() -> void:
	if weapon_container.get_child_count() == 0:
		return
	var weapon = weapon_container.get_child(current_weapon_index)
	if weapon and weapon.has_method("use_weapon"):
		weapon.use_weapon()

func cycle_weapon() -> void:
	if weapon_container.get_child_count() == 0:
		return
	current_weapon_index = (current_weapon_index + 1) % weapon_container.get_child_count()
	print("Arme sélectionnée : ", current_weapon_index + 1)

# --- GESTION DES ARMES ---
func add_weapon(weapon_scene: PackedScene) -> void:
	if weapon_scene in owned_weapons:
		print("Arme déjà possédée : ", weapon_scene.resource_path.get_file())
		return
	if weapon_scene:
		var weapon_instance = weapon_scene.instantiate()
		weapon_container.add_child(weapon_instance)
		owned_weapons.append(weapon_scene)
		print("Arme équipée dans le conteneur : ", weapon_instance.name)

# --- SANTÉ ET VIE ---
func take_damage(amount: float) -> void:
	current_health = max(current_health - amount, 0)
	if health_bar:
		health_bar.value = current_health
	if current_health <= 0:
		die()

func die() -> void:
	if death_menu_shown:
		return
	death_menu_shown = true
	print("GAME OVER ! Affichage du menu de mort.")
	var death_menu = load(DEATH_MENU_SCENE).instantiate()
	get_tree().current_scene.add_child(death_menu)
	if death_menu.has_method("open"):
		death_menu.open()

func heal_to_max() -> void:
	max_health = GameManager.max_health
	current_health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	print("DEBUG: Santé restaurée automatiquement à : ", current_health)
