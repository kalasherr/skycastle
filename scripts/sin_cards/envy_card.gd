extends SinCard

class_name EnvyCard

func apply():
	if G.ASC.get_children() != []:
		var card = G.ASC.get_node("Cards").get_children().pick_random()
		while card is EnvyCard:
			card = G.ASC.get_node("Cards").get_children().pick_random()
		await card.apply()
	return
	
#translate
func get_text():
	return ["Envy", "Apply random sin card that you already have again"]
