extends Node2D

class_name CardManager

var card_count = 3
var back
var front

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
	
	await T.tween(card, "scale", Vector2(0.5, 0.5), 0.2)
	
	var target_position = Vector2(760, 340) / 2
	if self is SinCardManager:
		target_position = Vector2(-760, 340) / 2

	var graph = func(x):
		if x < 0.2:
			return  (((x - 0.1) ** 2) * 10.0 - 0.1)
		else:
			return - ((x - 1.0) ** 2) * 1.25 * 1.25 + 1.0
	back.destroy()
	
	await T.tween(card, "init_position", target_position, G.card_apply_time, graph)
	
	if back:
		await get_tree().create_timer(max(0,back.destroy_time - G.card_apply_time)).timeout

	card.init_position = target_position
	card.able()
	card.reparent(applied.get_node("Cards"))
	card.light_mask = 1
	await card.apply()
	emit_signal("card_applied")
	applied.enable_cards()
	G.GS.controller_enabled = true
	for applied in G.AC.get_node("Cards").get_children():
		for child in applied.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_PASS
	for applied in G.AC.get_node("Cards").get_children():
		for child in applied.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_PASS
	return

func call_cards(next_turn = false):
	for applied in G.AC.get_node("Cards").get_children():
		for child in applied.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for applied in G.AC.get_node("Cards").get_children():
		for child in applied.get_children():
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	call_background()
	G.GS.controller_enabled = false
	applied.hide_cards(next_turn)
	applied.disable_cards()
	var to_pick = generate_cards()
	for card in to_pick:
		card.position.y = -1000
		card.init_position.y = 0
		card.init_position.x = - 480 + (to_pick.find(card) + 1) * (960.0 - to_pick.size() * card.card_size.x) / (to_pick.size() + 1) + card.card_size.x * (to_pick.find(card) + 0.5)
		card.light_mask = 2
		cards.add_child(card)

	T.tween(back, "modulate", Color(1,1,1,0.8), 0.2)
	

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

func call_background():
	back = load("res://scenes/stuff/cards/card_manager_background.tscn").instantiate()
	back.name = "Background"
	back.position.x = -1000
	back.position.y = -1000
	back.modulate[3] = 0
	back.z_index = -1
	back.inited = true
	add_child(back)
