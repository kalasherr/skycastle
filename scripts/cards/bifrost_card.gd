extends Card

class_name BifrostCard

func apply():
	for i in range(0,values["value1"]):
		var tile = BridgeTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

func set_values():
	values.value1 = 7
	
func get_key():
	return "bifrost"