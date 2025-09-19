extends Tile

class_name GunpowderStorageTile

var exploded = false

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/gunpowder_storage.png")
	return [sprite,rot, offset]

func destroy(flag = ""):
	if !is_destroying and !exploded:
		exploded = true
		if !G.GS.stage_transfer:
			for i in [-1,0,1]:
				for j in [-1,0,1]:
					if G.GS.get_tile(tile_coords + Vector2(i,j)) and (i != 0 or j != 0) and tile_coords.x + i >= 0 and tile_coords.y + j >= 0 and tile_coords.x + i < G.GS.board_size.x and tile_coords.y + j < G.GS.board_size.y:
						var found = false
						for effect in G.GS.get_tile(tile_coords + Vector2(i,j)).get_node("Effects").get_children():
							if effect is CrownEffect:
								found = true
						if !found and !G.GS.get_tile(tile_coords + Vector2(i,j)).is_destroying:
							G.GS.get_tile(tile_coords + Vector2(i,j)).destroy()
		default_destroy()

func get_key():
	return "gunpowder_storage"