extends TileEffect

class_name WeaponryEffect

func on_enter():
	G.player.get_shield(1)
	queue_free()