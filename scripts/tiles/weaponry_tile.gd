extends Tile

class_name WeaponryTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/weaponry.png")
	if tile_moves.find(Vector2(1,0)) != -1:
		rot = deg_to_rad(90)
	return [sprite,rot, offset]

func init_effects():
	add_effect("weaponry")

func get_key():
	return "weaponry"