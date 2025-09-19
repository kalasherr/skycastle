extends Card

class_name MonolithCard

var stone_amount = 6

func apply():
	for i in range(0,stone_amount):
		var tile = load("res://scenes/tiles/stone_tile.tscn").instantiate()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)

func set_values():
	values.value1 = stone_amount

func get_key():
	return "monolith"