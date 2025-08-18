extends Card

class_name SmiteCard

func apply():
	var tile = load("res://scenes/tiles/weaponry_tile.tscn").instantiate()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
	tile = load("res://scenes/tiles/gunpowder_storage_tile.tscn").instantiate()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	return ["Smite", "Adds weaponry and gunpowder storage to your deck"]
