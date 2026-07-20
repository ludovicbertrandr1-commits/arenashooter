extends Control

# Tu n'as même plus besoin de SCENE_CLASSIQUE ici !
const CHAR_SELECT_SCENE = "res://scenes/levels/character_selection_menu.tscn"

func _ready() -> void:
	# Connecte les signaux des boutons
	$CenterContainer/VBoxContainer/BtnClassique.pressed.connect(_on_classique_pressed)
	$CenterContainer/VBoxContainer/BtnEnvahisseur.pressed.connect(_on_envahisseur_pressed)

func _on_classique_pressed() -> void:
	# 1. On mémorise le choix du mode dans le GameManager
	GameManager.current_mode = "classique"
	
	# 2. On change d'écran pour aller choisir le perso UNIQUEMENT
	get_tree().change_scene_to_file(CHAR_SELECT_SCENE)

func _on_envahisseur_pressed() -> void:
	# Pour l'instant, on affiche juste un message
	print("Le mode Envahisseur sera disponible dans une prochaine mise à jour !")
	# Optionnel : Ajoute un Label pour afficher ce texte à l'écran
