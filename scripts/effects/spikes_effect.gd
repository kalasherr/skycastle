extends TileEffect

class_name SpikesEffect

func on_enter():
	G.player.take_damage(1)
