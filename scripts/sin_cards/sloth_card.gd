extends SinCard

class_name SlothCard

func apply():
	add_stones()
	G.GS.choice_modifier -= 1
	return

#translate
func get_text():
	return ["Sloth", "1 option less for every choice"]