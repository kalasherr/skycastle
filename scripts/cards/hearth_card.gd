extends Card

class_name HearthCard

func apply():
	var tile = FireplaceTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
	tile = CrematoriumTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

func get_key():
	return "hearth"