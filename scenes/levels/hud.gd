extends CanvasLayer

@onready var score_label = $Label

func _process(_delta: float) -> void:
	if score_label:
		score_label.text = "Coins : " + str(GameManager.coins)
