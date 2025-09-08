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

#translate
func get_text():
	values["value1"] = 2
	return ["Wildfire", "[color={add}]Adds[/color] {value1} bonfires and crematorium to your deck".format(values)]