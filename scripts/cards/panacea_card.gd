extends Card

class_name PanaceaCard

func apply():
	var tile = InfirmaryTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)

func heal():
	G.player.heal(values["value1"])

func init():
	G.GS.connect("next_stage_started", heal)
	default_init()

func set_values():
	values.values1 = 1

func get_key():
	return "panacea"