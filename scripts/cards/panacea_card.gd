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

#translate
func get_text():
	values["value1"] = 1
	return ["Panacea", "[color={add}]Adds[/color] infirmary tile to your deck and [color={add}]heals[/color] {value1} health when stage starts".format(values)]
