extends Node2D

class_name CardManager

var card_count = 3

@onready var cards = get_node("Cards")

signal card_applied

var card_deck = []
@onready var applied = get_parent().get_node("AppliedCards")

func _ready():
	G.CM = self
	
func init():
	pass

func destroy_other_cards(card):
	var f = func():
		for child in cards.get_children():
			child.disable()
			if child != card:
				if self is SinCardManager:
					G.GS.unused_sin_cards.append(child.option)
				else:
					G.GS.unused_cards.append(child.option)
				child.destroy()	
				
	await f.call()
	
	var init_time = 0.2
	var curr_time = 0.0

	var target_scale = Vector2(0.5,0.5)
	
	while card.scale > target_scale:
		card.scale = target_scale * curr_time / init_time + Vector2(1,1) * (1 - curr_time / init_time)
		curr_time += get_process_delta_time() * G.animation_time_scale
		await get_tree().process_frame

	card.scale = target_scale 
	
	init_time = G.card_apply_time
	curr_time = 0.0
	
	var target_position = Vector2(760, 340) / 2
	if self is SinCardManager:
		target_position = Vector2(-760, 340) / 2
	var start_position = card.init_position
	
	var graph = func(x):
		if x < init_time/5.0:
			return 0.75 * (((x/init_time - 0.1) ** 2) * 10.0 - 0.1)
		else:
			return - ((x/init_time - 1) ** 2) * 1.25 * 1.25 + 1
	
	while curr_time < init_time:
		card.init_position = graph.call(curr_time) * target_position + (1 - graph.call(curr_time)) * start_position
		curr_time += get_process_delta_time() * G.animation_time_scale
		await get_tree().process_frame

	card.init_position = target_position
	card.able()
	card.reparent(applied.get_node("Cards"))
	await card.apply()
	emit_signal("card_applied")
	applied.enable_cards()
	return

func call_cards(next_turn = false):
	applied.hide_cards(next_turn)
	applied.disable_cards()
	var to_pick = generate_cards()
	for card in to_pick:
		card.init_position.y = 0
		card.init_position.x = - 480 + (to_pick.find(card) + 1) * (960.0 - to_pick.size() * card.card_size.x) / (to_pick.size() + 1) + card.card_size.x * (to_pick.find(card) + 0.5)
		cards.add_child(card)

func generate_cards():
	var to_return = []
	var pool = G.GS.unused_cards
	for i in range(0,max(1, card_count + G.GS.choice_modifier)):
		var card_name = pool.pick_random()
		pool.pop_at(pool.find(card_name))
		var card = load("res://scenes/cards/" + card_name).instantiate()
		card.option = card_name
		to_return.append(card)
	return to_return
