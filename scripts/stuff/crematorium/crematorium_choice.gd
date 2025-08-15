extends Node2D

class_name CrematoriumChoice

signal event_ended

func _ready():
	init()

func init():
	var tiles = []
	for i in range(1, G.GS.current_deck.size()):
		tiles.append(G.GS.current_deck[i])
	for i in range(0,min(3,tiles.size() - 1)):
		var choice = TileChoice.new()
		choice.init()
		var tile = tiles.pick_random()
		tiles.pop_at(tiles.find(tile))
		choice.position.x = (i - 1) * 200
		choice.get_node("Sprite").texture = tile.get_sprite()[0]
		if tile.get_sprite().size() == 3:
			choice.get_node("Sprite").position = tile.get_sprite()[2]
		choice.bound_tile = tile
		add_child(choice)

func choose(tile):
	G.GS.delete_tile(tile)
	for child in get_children():
		child.get_node("Button").disabled = false
	var init_time = 1.0
	var curr_time = 0.0
	var curr_scale = get_child(0).scale
	while curr_time < init_time:
		for child in get_children():
			child.scale = curr_scale * (1 - curr_time / init_time)
		await get_tree().process_frame
		curr_time += get_process_delta_time()
	for child in get_children():
		child.queue_free()
	emit_signal("event_ended")
