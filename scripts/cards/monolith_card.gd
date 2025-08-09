extends Card

class_name MonolithCard

func apply():
	for i in range(0,8):
		var tile = load("res://scenes/tiles/stone_tile.tscn").instantiate()
		var moves = []
		G.GS.add_tile_to_deck(tile, moves)
		
