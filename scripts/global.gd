extends Node

var total_gold: int = 0

func add_gold(amount: int):
	total_gold += amount
	print("Or actuel : ", total_gold)

# Cette variable contiendra le chemin vers la scène du personnage (ex: "res://player1.tscn")
var selected_character_path: String = ""
