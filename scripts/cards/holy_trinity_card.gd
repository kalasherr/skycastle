extends Card

class_name HolyTrinityCard

func apply():
	for i in range(0,3):
		var tile = AlmshouseTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	return ["Holy Trinity", "Adds 3 almshouses to your deck"]
