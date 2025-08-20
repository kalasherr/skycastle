extends TileEffect

class_name FireplaceEffect

func on_enter():
	G.player.heal(2)
	queue_free()