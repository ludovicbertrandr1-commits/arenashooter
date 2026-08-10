extends CanvasLayer

const MAIN_MENU_PATH: String = "res://scenes/levels/main_menu.tscn"

func open() -> void:
	# Permettre aux contrôles d'être cliquables même quand le jeu est en pause
	var pause_process_value: int = 2
	if has_method("set_pause_mode"):
		set_pause_mode(pause_process_value)
	elif "pause_mode" in self:
		pause_mode = pause_process_value
	visible = true
	# Assure que les enfants UI acceptent aussi les entrées pendant la pause
	for child in get_children():
		if child and child.has_method("set_pause_mode"):
			child.set_pause_mode(pause_process_value)
		elif child and "pause_mode" in child:
			child.pause_mode = pause_process_value
	get_tree().paused = true

func _on_btn_restart_pressed() -> void:
	# Remet le solde de la run à zéro, conserve le personnage sélectionné
	GameManager.coins = 0
	# Dépauser avant de recharger la scène pour éviter blocage d'input
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_main_menu_pressed() -> void:
	GameManager.coins = 0
	GameManager.current_mode = ""
	GameManager.selected_character = null
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
