extends TileEffect

class_name CrownEffect

func on_enter():
	G.GS.next_stage()
	queue_free()
	
func get_effect_name():
	return "crown"
