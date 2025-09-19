extends Tile

class_name MonasticCellTile

func init_effects():
	add_effect("monastic_cell")

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/monastic_cell.png")
	match tile_moves[0]:
		Vector2(-1,0):
			rot = deg_to_rad(90)
		Vector2(1,0):
			rot = deg_to_rad(-90)
		Vector2(0,-1):
			rot = deg_to_rad(180)
	return [sprite,rot, offset]

func get_key():
	return "monastic_cell"