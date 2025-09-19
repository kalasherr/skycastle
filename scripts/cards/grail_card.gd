extends Card

class_name GrailCard

func apply():
	var tile = MausoleumTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
	tile = MonasticCellTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

func get_key():
	return "grail"