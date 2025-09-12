extends Card

class_name CrusaderCard

func apply():
	for i in range(0, values["value1"]):
		var tile = WeaponryTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)	
	for i in range(0, values["value2"]):
		var tile = ChapelTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	values["value1"] = 2
	values["value2"] = 1	
	return ["Crusader", "[color={add}]Add[/color] chapel and {value1} armories to your deck".format(values)]