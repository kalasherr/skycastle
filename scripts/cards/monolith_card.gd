extends Card

class_name MonolithCard

func apply():
	for i in range(0,6):
		var tile = load("res://scenes/tiles/stone_tile.tscn").instantiate()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

#translate
func get_text():
	return ["Monolith", "Adds 6 stones to your deck"]
