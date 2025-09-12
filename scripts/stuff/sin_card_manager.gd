extends CardManager

class_name SinCardManager

func _ready():
	G.SCM = self
	cards = get_node("Cards")
	card_deck = []
	applied = get_parent().get_node("AppliedSinCards")
	card_count = 2
	connect("card_applied", next_turn)
	
func init():
	pass

func generate_cards():
	var to_return = []
	var pool = G.GS.unused_sin_cards
	for card in G.AC.get_node("Cards").get_children():
		if card is CenserCard:
			card_count = 3
	for i in range(0,max(1, card_count + G.GS.choice_modifier)):
		var card_name = pool.pick_random()
		pool.pop_at(pool.find(card_name))
		var card = load("res://scenes/sin_cards/" + card_name).instantiate()
		card.option = card_name
		to_return.append(card)
	return to_return

func next_turn():
	G.GS.next_turn()
