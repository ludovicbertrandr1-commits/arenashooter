extends Control

# Remplace par le chemin réel vers ta scène de jeu actuelle
const SCENE_CLASSIQUE = "res://scenes/levels/arena.tscn" 

func _ready() -> void:
	# Connecte les signaux des boutons
	$CenterContainer/VBoxContainer/BtnClassique.pressed.connect(_on_classique_pressed)
	$CenterContainer/VBoxContainer/BtnEnvahisseur.pressed.connect(_on_envahisseur_pressed)

func _on_classique_pressed() -> void:
	# Charge la scène classique
	get_tree().change_scene_to_file(SCENE_CLASSIQUE)

func _on_envahisseur_pressed() -> void:
	# Pour l'instant, on affiche juste un message
	print("Le mode Envahisseur sera disponible dans une prochaine mise à jour !")
	# Optionnel : Ajoute un Label pour afficher ce texte à l'écran
