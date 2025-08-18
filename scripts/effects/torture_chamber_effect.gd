extends TileEffect

class_name TortureChamberEffect

func on_enter():
	var tile = TortureChamberTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
