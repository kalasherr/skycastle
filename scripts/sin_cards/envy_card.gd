extends SinCard

class_name EnvyCard

func apply():
	var found = false
	for child in G.ASC.get_node("Cards").get_children():
		if !(child is EnvyCard):
			found = true
	if found:
		var card = G.ASC.get_node("Cards").get_children().pick_random()
		while card is EnvyCard:
			card = G.ASC.get_node("Cards").get_children().pick_random()
		await card.apply()
	G.GS.next_turn()
	return
	
#translate
func get_text():
	return ["Envy", "Apply random sin card that you already have again"]
