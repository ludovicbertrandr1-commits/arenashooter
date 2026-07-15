extends CanvasLayer

@onready var fade_overlay = $FadeOverlay

func change_scene(path: String):
	# 1. Créer un Tween pour l'animation
	var tween = create_tween()
	
	# 2. Fondu au noir (alpha devient 1.0)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.5)
	
	# 3. Attendre que le noir soit complet
	await tween.finished
	
	# 4. Charger la nouvelle scène
	get_tree().change_scene_to_file(path)
	
	# 5. Créer un nouveau Tween pour le retour
	tween = create_tween()
	
	# 6. Fondu en ouverture (alpha devient 0.0)
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 0.5)
