extends Card

class_name BifrostCard

func apply():
	for i in range(0,7):
		var tile = BridgeTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

#translate
func get_text():
	return ["Bifrost", "Adds 7 bridges to your deck"]