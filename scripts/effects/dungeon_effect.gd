extends TileEffect

class_name DungeonEffect

func on_enter():
	var tile = DungeonTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
