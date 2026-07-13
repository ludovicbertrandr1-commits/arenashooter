extends CharacterBody2D

# --- STATISTIQUES ---
@export var max_health: float = 100.0
@export var speed: float = 300.0

# --- CONFIGURATION (À remplir dans l'inspecteur) ---
# Glisse ici les armes de départ propres à CHAQUE personnage
@export var starting_weapons: Array[PackedScene] = []

# --- ÉTAT INTERNE ---
var current_health: float
var owned_weapons: Array[PackedScene] = []

# --- NŒUDS ---
@onready var health_bar = $HealthBar
@onready var weapon_container = $WeaponsContainer

func _ready() -> void:
	current_health = max_health
	setup_ui()
	
	# --- CODE DE DEBUG ---
	print("DEBUG : Nombre d'armes de départ configurées : ", starting_weapons.size())
	
	for weapon in starting_weapons:
		# Cette ligne affiche le chemin du fichier pour vérifier s'il est bien chargé
		print("DEBUG : Tentative d'ajout de : ", weapon.resource_path)
		add_weapon(weapon)

func setup_ui() -> void:
	if has_node("HealthBar"):
		health_bar.max_value = max_health
		health_bar.value = current_health

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	move_and_slide()

# --- GESTION DES ARMES ---
func add_weapon(weapon_scene: PackedScene) -> void:
	# Sécurité : On vérifie si l'arme est déjà dans la liste
	if weapon_scene in owned_weapons:
		print("Arme déjà possédée : ", weapon_scene.resource_path.get_file())
		return

	if weapon_scene:
		var weapon_instance = weapon_scene.instantiate()
		weapon_container.add_child(weapon_instance) # On ajoute l'arme dans le conteneur
		owned_weapons.append(weapon_scene)
		print("Arme équipée dans le conteneur : ", weapon_instance.name)

# --- SANTÉ ET VIE ---
func take_damage(amount: float) -> void:
	current_health -= amount
	if health_bar:
		health_bar.value = current_health
	
	if current_health <= 0:
		die()

func die() -> void:
	print("GAME OVER !")
	Global.total_gold = 0 
	get_tree().call_deferred("reload_current_scene")

func heal_to_max():
	current_health = max_health
	if has_node("HealthBar"):
		health_bar.value = current_health
	print("DEBUG: Santé restaurée au max !")
