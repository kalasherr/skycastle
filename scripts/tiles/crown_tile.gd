extends Tile

class_name CrownTile

func init_effects():
	add_effect("crown")

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/crown_tile.png")
	return [sprite,rot, offset]
	

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]