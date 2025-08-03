extends Tile

class_name BankTile

func post_init():
	add_effect("coin")

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/bank.png")
	match tile_moves[0]:
		Vector2(-1,0):
			rot = deg_to_rad(90)
		Vector2(1,0):
			rot = deg_to_rad(-90)
		Vector2(0,-1):
			rot = deg_to_rad(180)
	return [sprite,rot]


func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]