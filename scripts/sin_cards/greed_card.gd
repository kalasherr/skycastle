extends SinCard

class_name GreedCard

func apply():
	add_stones()
	G.player.update_money(- int(G.player.money / 2))
	return
	
#translate
func get_text():
	return ["Greed", "Lose half of your money"]
