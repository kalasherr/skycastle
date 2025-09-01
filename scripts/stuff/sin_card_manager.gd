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
	var pool = G.get_sin_card_pool()
	for i in range(0,card_count):
		var card_name = pool.pick_random()
		pool.pop_at(pool.find(card_name))
		var card = load("res://scenes/sin_cards/" + card_name).instantiate()
		to_return.append(card)
	return to_return

func next_turn():
	G.GS.next_turn()
