extends Tile

class_name CrematoriumTile

func init_effects():
	add_effect("crematorium")

func get_sprite():
	var sprite
	var rot = 0
	var offset = Vector2(0,-8)
	sprite = load("res://sprites/tiles/crematorium.png")
	return [sprite,rot,offset]

func rotatable():
	return false