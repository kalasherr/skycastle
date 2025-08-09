extends Node2D

class_name AppliedCards

var shown = false
var last_turn

func show_all_cards():
	if !shown:
		var cards = get_node("Cards").get_children()
		for i in range(0,cards.size()):
			cards[i].init_position.x -= ((cards[i].card_size.x + 20) * i * cards[i].scale.x)
		G.GS.disable_buttons()
		if G.GS.game_phase == "player":
			last_turn = "tile"
		else:
			last_turn = "player"
		shown = true
	else:
		var cards = get_node("Cards").get_children()
		for i in range(0,cards.size()):
			cards[i].init_position.x += ((cards[i].card_size.x + 20) * i * cards[i].scale.x)
		shown = false
		G.GS.game_phase = last_turn
		G.GS.next_turn()
