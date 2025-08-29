extends SinCard

class_name PrideCard

func apply():
	add_stones()
	G.player.hp = 1
	G.GS.change_hp(1)
	return

#translate
func get_text():
	return ["Pride", "Lose all hp to 1"]