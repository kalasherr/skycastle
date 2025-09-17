extends Node2D

class_name MonasticCellChoice

signal event_ended

func _ready():
	init()

func init():
	var tiles = []
	var to_choose = G.get_tile_pool()
	to_choose.pop_at(to_choose.find("crown_tile.tscn"))
	to_choose.pop_at(to_choose.find("basic_tile.tscn"))
	for i in range(0, to_choose.size()):
		tiles.append(load("res://scenes/tiles/" + to_choose[i]).instantiate())
	if tiles != [] and tiles.size() + G.GS.choice_modifier > 0:
		var tiles_count = min(3 ,tiles.size()) + G.GS.choice_modifier
		for i in range(0,tiles_count):
			var choice = TileChoice.new()
			choice.init()
			var tile = tiles.pick_random()
			tiles.pop_at(tiles.find(tile))
			choice.position.x = - 480 + (i + 1) * (960.0 - tiles_count * G.tile_size.x) / (tiles_count + 1) + G.tile_size.x * (i + 0.5)
			choice.get_node("Sprite").texture = tile.get_sprite()[0]
			if tile.get_sprite().size() == 3:
				choice.get_node("Sprite").position = tile.get_sprite()[2]
			choice.bound_tile = tile
			add_child(choice)
		set_text()

func choose(tile):
	for child in get_children():
		if child is TileChoice:
			child.get_node("Button").disabled = true
	G.GS.add_tile_to_deck(tile, G.GS.get_tile_moves(tile))
	for child in get_children():
		T.tween(child, "scale", Vector2(0,0), 1.0)
	await get_tree().create_timer(1).timeout
	for child in get_children():
		child.queue_free()
	emit_signal("event_ended")
	queue_free()

func set_text():
	var label = Label.new()
	add_child(label)
	label.text = "Choose tile to add to deck"
	label.position = Vector2(-400,-200)
	label.modulate = Color.GREEN
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(400,100)
	label.scale = Vector2(2,2)
