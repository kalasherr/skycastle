extends Tile

class_name BridgeTile

func deploy_effect():
	for i in [0,1]:
		var coords = Vector2(round((tile_coords + tile_moves[i].rotated(deg_to_rad(90))).x), round((tile_coords + tile_moves[i].rotated(deg_to_rad(90))).y))
		if G.GS.get_tile(coords):
			var crown = false
			for effect in G.GS.get_tile(coords).get_node("Effects").get_children():
				if effect is CrownEffect:
					crown = true
			if !(G.GS.get_tile(coords) is BridgeTile or G.GS.get_tile(coords) is WaterTile or crown):
				G.GS.tile_deck.pop_at(G.GS.tile_deck.find(G.GS.get_tile(coords).tile_in_deck))
				G.GS.get_tile(coords).destroy()
				await get_tree().create_timer(G.tile_destroy_time / G.animation_time_scale).timeout
				var tile = WaterTile.new()
				G.GS.add_tile_to_deck(tile, [])
				var tile_to_place = WaterTile.new()
				tile_to_place.tile_in_deck = tile
				tile_to_place.tile_moves = []
				tile_to_place.tile_coords = coords
				G.GS.get_node("TileManager").add_child(tile_to_place)
				tile_to_place.init()

func get_sprite():
	var sprite = load("res://sprites/tiles/bridge.png")
	var rot = 0
	if tile_moves.find(Vector2(1,0)) != -1:
		rot = deg_to_rad(90)
	return [sprite,rot]
		
