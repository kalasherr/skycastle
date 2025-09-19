extends Tile

class_name MirrorChamberTile

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/mirror_chamber.png")
	return [sprite,rot, offset]

func init_effects():
	add_effect("spikes")

func destroy(flag = ""):
	if !is_destroying:
		if !G.GS.restarting and !G.GS.stage_transfer:
			G.GS.add_tile_to_deck("mirror_chamber")
		default_destroy()

func get_key():
	return "mirror_chamber"