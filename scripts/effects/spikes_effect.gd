extends TileEffect

class_name SpikesEffect

func on_enter():
	G.player.take_damage(1)

func get_effect_name():
	return "spikes"

