extends Tile

class_name ChapelTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/chapel.png")
	match tile_moves[0]:
		Vector2(-1,0):
			rot = deg_to_rad(90)
		Vector2(1,0):
			rot = deg_to_rad(-90)
		Vector2(0,-1):
			rot = deg_to_rad(180)
	return [sprite,rot, offset]

func init_effects():
	add_effect("fireplace")
