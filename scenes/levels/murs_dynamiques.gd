extends Node2D

var murs = []

func _ready():
	# Création des 4 murs
	for i in range(4):
		var mur = StaticBody2D.new()
		var collision = CollisionShape2D.new()
		collision.shape = RectangleShape2D.new()
		mur.add_child(collision)
		add_child(mur)
		murs.append(mur)
	
	# Ajustement initial
	_ajuster_murs()
	
	# Mise à jour si la fenêtre est redimensionnée
	get_tree().root.size_changed.connect(_ajuster_murs)

func _ajuster_murs():
	var ecran = get_viewport_rect().size
	var epaisseur = 100
	
	# Mur du Haut [0] - Positionné au centre-haut
	murs[0].position = Vector2(0, -ecran.y / 2 - epaisseur / 2)
	murs[0].get_child(0).shape.size = Vector2(ecran.x, epaisseur)
	
	# Mur du Bas [1] - Positionné au centre-bas
	murs[1].position = Vector2(0, ecran.y / 2 + epaisseur / 2)
	murs[1].get_child(0).shape.size = Vector2(ecran.x, epaisseur)
	
	# Mur de Gauche [2] - Positionné au centre-gauche
	murs[2].position = Vector2(-ecran.x / 2 - epaisseur / 2, 0)
	murs[2].get_child(0).shape.size = Vector2(epaisseur, ecran.y)
	
	# Mur de Droite [3] - Positionné au centre-droit
	murs[3].position = Vector2(ecran.x / 2 + epaisseur / 2, 0)
	murs[3].get_child(0).shape.size = Vector2(epaisseur, ecran.y)
