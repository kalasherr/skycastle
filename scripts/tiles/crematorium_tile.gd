extends Tile

class_name CrematoriumTile

func init_effects():
	add_effect("crematorium")

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/crematorium.png")
	offset = -(sprite.get_size() - G.tile_size) / 2
	return [sprite, rot, offset]

func rotatable():
	return false
