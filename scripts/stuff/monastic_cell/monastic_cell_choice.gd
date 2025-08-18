extends Node2D

class_name MonasticCellChoice

signal event_ended

func _ready():
	init()

func init():
	var tiles = G.get_tile_pool()
	tiles.pop_at(tiles.find("basic_tile.tscn"))
	tiles.pop_at(tiles.find("crown_tile.tscn"))
	for i in range(0,3):
		var choice = TileChoice.new()
		choice.init()
		var tile_string = tiles.pick_random()
		tiles.pop_at(tiles.find(tile_string))
		var tile = load("res://scenes/tiles/" + tile_string).instantiate()
		choice.position.x = (i - 1) * 200
		choice.get_node("Sprite").texture = tile.get_sprite()[0]
		if tile.get_sprite().size() == 3:
			choice.get_node("Sprite").position.y = tile.get_sprite()[2].y
		choice.bound_tile = tile
		add_child(choice)
	var label = Label.new()
	add_child(label)
	label.text = "Choose tile to add to deck"
	label.position = Vector2(-400,-200)
	label.modulate = Color.GREEN
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(400,100)
	label.scale = Vector2(2,2)

func choose(tile):
	G.GS.add_tile(tile.bound_tile)
	for child in get_children():
		if child is TileChoice:
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
