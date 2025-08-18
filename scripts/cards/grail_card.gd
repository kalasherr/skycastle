extends Card

class_name GrailCard

func apply():
	var tile = MausoleumTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
	tile = MonasticCellTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	return ["Grail", "Adds mausoleum and monastic cell to your deck"]
