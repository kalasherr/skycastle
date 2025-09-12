extends Card

class_name HolyTrinityCard

func apply():
	for i in range(0,values["value1"]):
		var tile = AlmshouseTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)	

#translate
func get_text():
	values["value1"] = 3
	return ["Holy Trinity", "[color={add}]Add[/color] {value1} almshouses to your deck".format(values)]

func get_illustration():
	return "res://sprites/cards/holy_trinity_card.png"