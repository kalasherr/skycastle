extends Card

class_name WildfireCard

func apply():
	for i in range(0,values["value1"]):
		var tile = CampfireTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)
	var tile = CrematoriumTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

func set_values():
	values["value1"] = 2

func get_key():
	return "wildfire"