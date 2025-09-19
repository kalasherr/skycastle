extends Tile

class_name TortureChamberTile

func init_effects():
	add_effect("spikes")
	add_effect("torture_chamber")
	
func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/torture_chamber.png")
	var normal = tile_moves[0] + tile_moves[1] + tile_moves[2]

	if tile_moves.find(Vector2(0,-1)) == -1:
		rot = deg_to_rad(0)
	elif tile_moves.find(Vector2(0,1)) == -1:
		rot = deg_to_rad(180)
	elif tile_moves.find(Vector2(-1,0)) == -1:
		rot = deg_to_rad(-90)
	elif tile_moves.find(Vector2(1,0)) == -1:
		rot = deg_to_rad(90)

	return [sprite,rot, offset]

func get_key():
	return "torture_chamber"