extends Node

@export var bullet_scene: PackedScene
@export var rateau_scene: PackedScene

var total_gold: int = 0
var bonus_damage: int = 0 # C'est cette variable que le Shop va augmenter (+5)

func add_gold(amount: int):
	total_gold += amount
	print("Or actuel : ", total_gold)

# Cette variable contiendra le chemin vers la scène du personnage (ex: "res://player1.tscn")
var selected_character_path: String = ""

# --- Dans Global.gd ---
var player_damage : int = 10

# --- Dans le script du Shop ---
func _on_buy_damage_pressed():
	Global.player_damage += 5
	print("Dégâts actuels : ", Global.player_damage)

# --- Dans le script du Joueur ou de l'arme ---
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.damage = Global.player_damage # La balle prend la valeur globale
	get_tree().root.add_child(bullet)
