extends Node2D

class_name DeckShow

var current_deck = "tile"

func show_deck(deck):
	if deck == G.GS.current_deck:
		current_deck = "tile"
	elif deck == G.GS.tile_deck:
		current_deck = "curr"
	var deck_to_show = sort(deck)
	var camera = G.GS.camera
	var found = false
	for child in get_children():
		if child is ColorRect:
			found = true
	if !found:
		var space = ColorRect.new()
		space.z_index = 1
		space.mouse_filter = Control.MOUSE_FILTER_IGNORE
		space.size = Vector2(2000,2000)
		space.position = - Vector2(space.size.x / 2, get_viewport_rect().size.y / 2 + 20) 
		space.color = Color.BLACK
		space.name = "DeckSpace"
		add_child(space)
	else:
		for child in get_children():
			if child is TileToShow:
				child.destroy()
	var tile_space = Vector2(100,100)
	var scripts = []
	for i in range(0, deck_to_show.size()):
		found = false
		for script in scripts:
			if deck_to_show[i].get_script() == script:
				found = true
				break
		if !found:
			scripts.append(deck_to_show[i].get_script())
	scripts.sort()
	var rows = []
	for script in scripts:
		var tiles = []
		for tile in deck_to_show:
			if tile.get_script() == script:
				tiles.append(tile)
		rows.append(tiles)
	for i in range(0, rows.size()):
		var max_row_size = (get_viewport_rect().size.x) / G.GS.camera.zoom.x - 100
		var row_start = - max_row_size / 2
		for j in range(0, rows[i].size()):
			var tile = rows[i][j]
			var tile_to_show = TileToShow.new()
			tile.init_effects()
			var sprite = Sprite2D.new()
			var button = TextureButton.new()
			button.position -= G.tile_size / 2
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			button.texture_click_mask = load("res://sprites/tiles/tile_bitmap.png")
			button.name = "Button"
			tile_to_show.add_child(button)
			tile_to_show.z_index = 2
			
			sprite.texture = tile.get_sprite()[0]
			sprite.rotation = tile.get_sprite()[1]
			tile_to_show.final_position.x = row_start + min(max_row_size / rows[i].size(), tile_space.x) * j
			tile_to_show.final_position.y = i * tile_space.y - get_viewport_rect().size.y / 2 / G.GS.camera.zoom.x  + 100
			tile_to_show.position = Vector2(row_start, i * tile_space.y - get_viewport_rect().size.y / 2 / G.GS.camera.zoom.x  + 100)
			tile_to_show.add_child(sprite)
			add_child(tile_to_show)
			var effects = []
			var dir = DirAccess.open("res://sprites/effects")
			for effect in tile.effects_to_add:
				if dir.get_files().find(effect + "_effect.png") != -1:
					effects.append(load("res://sprites/effects/" + effect + "_effect.png"))
			for effect in effects:
				sprite.add_child(Sprite2D.new())
				sprite.get_child(sprite.get_children().size() - 1).rotation = - sprite.rotation
				sprite.get_child(sprite.get_children().size() - 1).texture = effect
			if tile.get_sprite().size() == 3:
				sprite.position += tile.get_sprite()[2]
				button.position += tile.get_sprite()[2]
				tile_to_show.button_shift = tile.get_sprite()[2]
				for effect in sprite.get_children():
					effect.position -= tile.get_sprite()[2]
			tile_to_show.init()

func sort(deck):
	var sorted = []
	var numbers = []
	for tile in deck:
		var number = 1000
		number += tile.tile_moves.size() * 100
		number += tile.effects_to_add.size() * 10
		number += tile.get_sprite()[1]
		numbers.append(number)
	var i = 0
	for j in range(0,numbers.size()):
		numbers[numbers.find(numbers.max())] = i
		i += 1
	for j in range(0, deck.size()):
		sorted.append(deck[numbers.find(j)])
	return sorted  
				
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if current_deck == "curr":
			show_deck(G.GS.current_deck)
		else:
			show_deck(G.GS.tile_deck)
