extends Node2D

class_name CardManager

var card_count = 3
@onready var cards = get_node("Cards")
signal CardApplied

var card_deck = []

func init():
	pass

func destroy_other_cards(card):
	var f = func():
		for child in cards.get_children():
			child.disable()
			if child != card:
				child.destroy()	
				
	await f.call()
	
	var init_time = 0.5
	var curr_time = 0.0

	var target_scale = Vector2(0.3,0.3)
	
	while card.scale > target_scale:
		card.scale = target_scale * curr_time / init_time + Vector2(1,1) * (1 - curr_time / init_time)
		curr_time += get_process_delta_time()
		await get_tree().process_frame

	card.scale = target_scale 
	
	init_time = 1.5
	curr_time = 0.0
	var target_position = Vector2(760, 340) / 2
	var start_position = card.init_position
	
	var graph = func(x):
		if x < init_time/5.0:
			return 0.75 * (((x/init_time - 0.1) ** 2) * 10.0 - 0.1)
		else:
			return - ((x/init_time - 1) ** 2) * 1.25 * 1.25 + 1
	
	while curr_time < init_time:
		card.init_position = graph.call(curr_time) * target_position + (1 - graph.call(curr_time)) * start_position
		curr_time += get_process_delta_time()
		await get_tree().process_frame

	card.init_position = target_position
	card.able()
	card.reparent(get_parent().get_node("AppliedCards/Cards"))
	await card.apply()
	emit_signal("CardApplied")
	
	return

func call_cards():
	for i in range(0,card_count):
		var card = CandleCard.new()
		card.init_position.y = 0
		card.init_position.x = ((960.0 - card_count * card.card_size.x) / (card_count + 1.0)) * (i - card_count / 2) + card.card_size.x * (i - card_count / 2)
		cards.add_child(card)

func get_card(card_name):
	return load("res://scenes/cards/" + card_name + "_card.tscn").instantiate()
