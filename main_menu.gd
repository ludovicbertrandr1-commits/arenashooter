extends Control

const CHAR_SELECT_SCENE = "res://scenes/levels/character_selection_menu.tscn"

func _ready() -> void:
	$CenterContainer/VBoxContainer/BtnClassique.pressed.connect(_on_classique_pressed)
	$CenterContainer/VBoxContainer/BtnEnvahisseur.pressed.connect(_on_envahisseur_pressed)

func _on_classique_pressed() -> void:
	GameManager.current_mode = "classique"
	get_tree().change_scene_to_file(CHAR_SELECT_SCENE)

func _on_envahisseur_pressed() -> void:
	GameManager.current_mode = "envahisseur"
	get_tree().change_scene_to_file(CHAR_SELECT_SCENE)
