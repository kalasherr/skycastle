extends Tile

class_name InfirmaryTile

func init_effects():
	add_effect("infirmary")

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/infirmary2.png")
	if tile_moves.find(Vector2(1,0)) != -1:
		sprite = load("res://sprites/tiles/infirmary1.png")
	return [sprite,rot]

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]
