extends Tile

class_name BellTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/bell_2.png")
	match tile_moves[0]:
		Vector2(-1,0):
			rot = deg_to_rad(90)
		Vector2(1,0):
			rot = deg_to_rad(-90)
		Vector2(0,-1):
			rot = deg_to_rad(180)
	return [sprite,rot, offset]
	
func get_player_offset():
	var player_offset = Vector2(0,14)
	match tile_moves[0]:
		Vector2(-1,0):
			return player_offset.rotated(deg_to_rad(90))
		Vector2(1,0):
			return player_offset.rotated(deg_to_rad(-90))
		Vector2(0,-1):
			return player_offset.rotated(deg_to_rad(180))
		Vector2(0,1):
			return player_offset

func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]
