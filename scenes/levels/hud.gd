extends CanvasLayer

# On utilise @onready pour lier le Label qui est enfant du CanvasLayer
@onready var score_label = $Label 

func _process(_delta: float) -> void:
	# On met à jour le texte du Label que l'on vient de lier
	if score_label:
		score_label.text = "Coins : " + str(Global.total_gold)
