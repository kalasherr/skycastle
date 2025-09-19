extends Tile

class_name CampfireTile

func get_sprite():
	var sprite = load("res://sprites/tiles/campfire.png")
	var rot = 0
	return [sprite,rot, offset]

func define_sprite():
	var sprite = load("res://scenes/stuff/campfire/fire_animation.tscn").instantiate()
	sprite.position += Vector2(0,-20)
	sprite.z_index = 1
	main_sprite.get_parent().add_child(sprite)
	sprite.animation = "fire"
	sprite.play()
	main_sprite.texture = get_sprite()[0]
	main_sprite.rotation = get_sprite()[1]

func deploy_effect():
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if G.GS.get_tile(tile_coords + Vector2(i,j)) and (i != 0 or j != 0) and !(G.GS.get_tile(tile_coords + Vector2(i,j)) is CrownTile):
				G.GS.get_tile(tile_coords + Vector2(i,j)).add_effect("coin")
				if G.GS.get_tile(tile_coords + Vector2(i,j)).tile_in_deck:
					G.GS.get_tile(tile_coords + Vector2(i,j)).tile_in_deck.add_effect("coin", true)
	await get_tree().create_timer(0.5).timeout
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if G.GS.get_tile(tile_coords + Vector2(i,j)) and (i != 0 or j != 0) and !(G.GS.get_tile(tile_coords + Vector2(i,j)) is CrownTile):
				G.GS.get_tile(tile_coords + Vector2(i,j)).destroy()

func get_key():
	return "campfire"