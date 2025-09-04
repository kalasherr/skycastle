extends Card

class_name BifrostCard

func apply():
	for i in range(0,colors["value1"]):
		var tile = BridgeTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

#translate
func get_text():
	colors["value1"] = 7
	return ["Bifrost", "[color={add}]Adds[/color] {value1} bridges to your deck".format(colors)]
