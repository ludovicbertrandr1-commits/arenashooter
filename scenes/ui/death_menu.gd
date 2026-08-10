extends CanvasLayer

const MAIN_MENU_PATH: String = "res://scenes/levels/main_menu.tscn"

func open() -> void:
	visible = true
	get_tree().paused = true

func _on_btn_restart_pressed() -> void:
	GameManager.coins = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_main_menu_pressed() -> void:
	GameManager.coins = 0
	GameManager.current_mode = ""
	GameManager.selected_character = null
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
