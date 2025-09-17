extends SinCard

class_name PrideCard

func apply():
	add_stones()
	G.player.hp = 1
	G.GS.update_hp(1)
	G.GS.next_turn()
	return

#translate
func get_text():
	return ["Pride", "Lose all hp to 1"]