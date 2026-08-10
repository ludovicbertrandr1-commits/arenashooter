extends CanvasLayer

@onready var label = $Label

func _process(_delta: float) -> void:
	label.text = "Coins : " + str(GameManager.coins)
