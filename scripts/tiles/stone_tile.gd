extends Tile

class_name StoneTile

func get_sprite():
	var sprite = load("res://sprites/tiles/stone_tile.png")
	var rot = 0
	return [sprite,rot]

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]
