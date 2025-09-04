extends Card

class_name HearthCard

func apply():
	var tile = FireplaceTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)
	tile = CrematoriumTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	return ["Hearth", "[color={add}]Adds[/color] fireplace and crematorium to your deck".format(colors)]
