extends Node2D

# --- Scènes et Références ---
@export var enemy_scene: PackedScene
@export var wave_label: Label
@export var time_label: Label
@export var wave_timer: Timer
@export var spawn_timer: Timer
@export var shop_ui: Node

# --- Configuration Spawn ---
@export var spawn_radius: float = 750.0
var base_spawn_time: float = 1.5
var time_elapsed: float = 0.0

# --- Configuration Vagues ---
@export var max_waves: int = 10
@export var basic_enemy_scene: PackedScene
@export var wave3_enemy_scene: PackedScene
@export var wave5_enemy_scene: PackedScene
@export var wave7_enemy_scene: PackedScene
@export var wave9_enemy_scene: PackedScene
var current_wave: int = 1

# --- Variables internes ---
var player: Node2D = null

# --- Fonctions Spawns ---
func get_enemy_to_spawn() -> PackedScene:
	var available_enemies = []
	if basic_enemy_scene: available_enemies.append(basic_enemy_scene)
	if current_wave >= 3 and wave3_enemy_scene: available_enemies.append(wave3_enemy_scene)
	if current_wave >= 5 and wave5_enemy_scene: available_enemies.append(wave5_enemy_scene)
	if current_wave >= 7 and wave7_enemy_scene: available_enemies.append(wave7_enemy_scene)
	if current_wave >= 9 and wave9_enemy_scene: available_enemies.append(wave9_enemy_scene)
	
	if available_enemies.size() > 0: return available_enemies.pick_random()
	return null

func _ready() -> void:
	if not spawn_timer or not wave_timer:
		push_error("ALERTE : Les timers ne sont pas assignés dans l'Inspecteur !")
		return
	
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# Sécurité : on s'assure que le timer de vague appellera bien la fin de vague
	if not wave_timer.timeout.is_connected(_on_wave_timer_timeout):
		wave_timer.timeout.connect(_on_wave_timer_timeout)
	
	start_wave()

func start_wave() -> void:
	if wave_label:
		wave_label.text = "Vague : " + str(current_wave) + "/" + str(max_waves)
	
	# Lancer les timers
	spawn_timer.start(base_spawn_time)
	wave_timer.start(get_wave_duration(current_wave))
	print("--- DÉBUT DE LA VAGUE : ", current_wave, " ---")

func get_wave_duration(wave: int) -> float:
	if wave <= 2: return 10.0
	elif wave <= 4: return 20.0
	else: return 30.0

# --- LOGIQUE DE PAUSE ET BOUTIQUE ---

func _on_wave_timer_timeout() -> void:
	# 1. Arrêter le spawn et le temps pendant la pause
	spawn_timer.stop()
	wave_timer.stop()
	
	# 2. Nettoyer le terrain
	clear_map() 
	
	# 3. Soigner le joueur
	if player and player.has_method("heal"):
		player.heal()
	
	# 4. Ouvrir la boutique
	# On utilise directement la variable qu'on a remplie dans l'Inspecteur !
	if shop_ui:
		if shop_ui.has_method("open_shop"):
			shop_ui.open_shop()
		else:
			print("ERREUR : Le script ShopUI.gd n'est pas attaché à la boutique !")
			start_next_wave()
	else:
		print("ERREUR : L'UI de la boutique n'est pas assignée dans l'Inspecteur !")
		start_next_wave()

# Cette fonction est appelée par le bouton "Reprendre" de ton ShopUI
func start_next_wave() -> void:
	if current_wave < max_waves:
		current_wave += 1
		time_elapsed = 0.0
		spawn_timer.wait_time = base_spawn_time
		start_wave()
	else:
		if time_label:
			time_label.text = "VICTOIRE !"
		print("--- VICTOIRE ! ---")

# --- Utilitaires ---

func _process(delta: float) -> void:
	time_elapsed += delta
	var speed_factor = floor(time_elapsed / 30.0)
	spawn_timer.wait_time = max(0.2, base_spawn_time - (speed_factor * 0.15))
	
	if time_label != null and not wave_timer.is_stopped():
		time_label.text = "Temps restant : " + str(int(wave_timer.time_left)) + "s"

func clear_map() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy): enemy.queue_free()
	for coin in get_tree().get_nodes_in_group("coins"):
		if is_instance_valid(coin): coin.queue_free()

func _on_spawn_timer_timeout() -> void:
	if not player: return
	var scene_to_spawn = get_enemy_to_spawn()
	if not scene_to_spawn: return
	
	var random_angle = randf_range(0, 2 * PI)
	var spawn_position = player.global_position + Vector2(cos(random_angle), sin(random_angle)) * spawn_radius
	spawn_position.x = clamp(spawn_position.x, -476.0, 476.0)
	spawn_position.y = clamp(spawn_position.y, -224.0, 225.0)
	
	var new_enemy = scene_to_spawn.instantiate()
	get_tree().current_scene.add_child(new_enemy)
	new_enemy.global_position = spawn_position
