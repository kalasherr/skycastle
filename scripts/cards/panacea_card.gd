extends Card

class_name PanaceaCard

func apply():
	var tile = InfirmaryTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)

func heal():
	G.player.heal(1)

func init():
	G.GS.connect("next_stage_started", heal)
	default_init()

#translate
func get_text():
	return ["Panacea", "Adds infirmary tile to your deck and heals 1 health when stage starts"]
