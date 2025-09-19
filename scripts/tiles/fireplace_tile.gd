extends Tile

class_name FireplaceTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/fireplace.png")
	var normal = tile_moves[0] + tile_moves[1]

	if int(rad_to_deg(normal.angle())) % 180 == 45:
		rot = deg_to_rad(0)
	elif int(rad_to_deg(normal.angle())) % 180 == -45:
		rot = deg_to_rad(-90)
	elif int(rad_to_deg(normal.angle())) % 180 == 135:
		rot = deg_to_rad(90)
	elif int(rad_to_deg(normal.angle())) % 180 == -135:
		rot = deg_to_rad(180)

	return [sprite,rot, offset]


func define_sprite():
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]

func deploy_effect():
	if G.player.hp > 1:
		G.player.take_damage(1)
		add_effect("fireplace")

func get_key():
	return "fireplace"