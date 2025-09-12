extends Card

class_name MonolithCard

var stone_amount = 6

func apply():

	for i in range(0,stone_amount):
		var tile = load("res://scenes/tiles/stone_tile.tscn").instantiate()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

#translate
func get_text():	
	values["value1"] = stone_amount
	return ["Monolith", "[color={add}]Add[/color] {value1} stones to your deck".format(values)]
