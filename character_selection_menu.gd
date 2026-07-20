extends Control

# Glisse tes scènes de persos (.tscn) dans l'inspecteur pour ces variables
@export var perso_1_scene: PackedScene
@export var perso_2_scene: PackedScene

# Remplace par le chemin exact de ta scène de combat
const ARENA_SCENE_PATH = "res://scenes/levels/arena.tscn"

func _on_btn_perso_1_pressed():
	GameManager.selected_character = perso_1_scene
	lancer_partie()

func _on_btn_perso_2_pressed():
	GameManager.selected_character = perso_2_scene
	lancer_partie()

func lancer_partie():
	# Optionnel : Tu peux ajouter ici une logique selon le mode de jeu
	print("Lancement du mode : ", GameManager.current_mode)
	get_tree().change_scene_to_file(ARENA_SCENE_PATH)
