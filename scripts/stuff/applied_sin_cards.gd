extends Node2D

class_name AppliedSinCards

var shown = false
var last_turn
var default_position = - 380

func hide_cards(next_turn = false):
	var cards = get_node("Cards").get_children()
	for i in range(0,cards.size()):
		cards[i].init_position.x = default_position
	shown = false
	G.GS.game_phase = last_turn
	if !next_turn:
		G.GS.next_turn()

func click():
	if shown:
		hide_cards()
	else:
		show_cards()

func show_cards():
	var cards = get_node("Cards").get_children()
	for i in range(0,cards.size()):
# 		cards[i].init_position.x -= ((cards[i].card_size.x + 20) * i * cards[i].scale.x)
		cards[i].init_position.x = ((cards[i].card_size.x + 20) * i * cards[i].scale.x) + default_position
	G.GS.disable_buttons()
	if G.GS.game_phase == "player":
		last_turn = "tile"
	else:
		last_turn = "player"
	shown = true

func disable_cards():
	for card in get_node("Cards").get_children():
		card.get_node("Button").disabled = true

func enable_cards():
	for card in get_node("Cards").get_children():
		card.get_node("Button").disabled = false

func destroy_all_cards():
	for child in get_node("Cards").get_children():
		child.queue_free()