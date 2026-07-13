extends CanvasLayer

@onready var label = $Label # Vérifie bien que le Label est bien un enfant direct du HUD

func _process(_delta: float) -> void:
	# À chaque image, on met à jour le texte du label avec la valeur globale
	label.text = "Coins : " + str(Global.total_gold)
