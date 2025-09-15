extends Tile

class_name GunpowderStorageTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/gunpowder_storage.png")
	return [sprite,rot, offset]

func destroy(flag = ""):
	if !is_destroying:
		is_destroying = true
		if !G.GS.stage_transfer:
			for i in [-1,0,1]:
				for j in [-1,0,1]:
					if G.GS.get_tile(tile_coords + Vector2(i,j)):
						var found = false
						for effect in G.GS.get_tile(tile_coords + Vector2(i,j)).get_node("Effects").get_children():
							if effect is CrownEffect:
								found = true
						if !found and !G.GS.get_tile(tile_coords + Vector2(i,j)).is_destroying:
							G.GS.get_tile(tile_coords + Vector2(i,j)).destroy()
		default_destroy()
